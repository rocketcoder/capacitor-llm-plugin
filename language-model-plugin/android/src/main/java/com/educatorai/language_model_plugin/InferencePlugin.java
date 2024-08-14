package com.educatorai.language_model_plugin;

import android.content.Context;
import android.content.res.AssetManager;
import android.os.FileUtils;
import android.util.Log;
import java.util.Optional;
import android.content.Context;
import androidx.annotation.NonNull;
import com.getcapacitor.Bridge;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.PluginMethod;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

import com.google.mediapipe.tasks.core.OutputHandler;
import com.google.mediapipe.tasks.genai.llminference.LlmInference;
import com.google.mediapipe.tasks.genai.llminference.LlmInference.LlmInferenceOptions;
;

@CapacitorPlugin(name = "Inference")
public class InferencePlugin extends Plugin {
    private static final String TAG = "InferencePlugin";
    private LlmInference cachedInference;
    private String resourcePath;
    private String currentId;
    @Override
    public void load() {
        super.load();
        resourcePath = loadResource();
    }
/*
    private String loadResource() {
        Context context = getContext();
        File modelFile = new File(context.getFilesDir(), "gemma-2b-it-gpu-int4.bin");

        if (!modelFile.exists()) {
            Log.e(TAG, "Resource not found. Add the gemma-2b model to your app resources");
            return "";
        }
        return modelFile.getAbsolutePath();
    }
*/
    private String loadResource() {
        Context context = getContext();
        AssetManager assetManager = context.getAssets();
        File modelFile = new File(context.getFilesDir(), "gemma-2b-it-gpu-int4.bin");

        if (!modelFile.exists()) {
            try (InputStream inputStream = assetManager.open("gemma-2b-it-gpu-int4.bin");
                 FileOutputStream outputStream = new FileOutputStream(modelFile)) {
                FileUtils.copy(inputStream, outputStream);
            } catch (IOException e) {
                Log.e("InferencePlugin", "Failed to copy model file", e);
                return "";
            }
        }
        return modelFile.getAbsolutePath();
    }

    private OutputHandler.ProgressListener<String> createProgressListener() {
        return new OutputHandler.ProgressListener<String>() {
            private boolean receivedFirstToken = false;

            @Override
            public void run(String result, boolean done) {
                if (done) {
                    receivedFirstToken = false;
                    notifyListeners("llm_end", new JSObject().put("value", result), true);
                } else if (!result.isEmpty()) {
                    receivedFirstToken = true;
                    notifyListeners("llm_partial", new JSObject().put("value", result), true);
                }
            }
        };
    }

    private LlmInference getInference() throws IOException {
        Context context = getContext();
        if (cachedInference != null) {
            return cachedInference;
        } else {
            OutputHandler.ProgressListener<String> resultListener = createProgressListener();
            LlmInferenceOptions.Builder options = LlmInferenceOptions.builder();
            options.setModelPath(resourcePath);
            options.setResultListener(resultListener);

            cachedInference = LlmInference.createFromOptions(context, options.build());
            return cachedInference;
        }
    }

    @PluginMethod
    public void generate(PluginCall call) {
        String inputPrompt = call.getString("value", "");
        String prompt = "<start_of_turn>user\n" + inputPrompt + "<end_of_turn>\n<start_of_turn>model\n";

        try {
            LlmInference inference = getInference();
            String result = inference.generateResponse(prompt);
            JSObject ret = new JSObject();
            ret.put("value", result);
            call.resolve(ret);
        } catch (Exception e) {
            Log.e(TAG, "Inference generation failed", e);
            call.reject("Failed to generate response", e);
        }
    }

    @PluginMethod
    public void generateStreaming(PluginCall call) {
        String inputPrompt = call.getString("value", "");
        String prompt = "<start_of_turn>user\n" + inputPrompt + "<end_of_turn>\n<start_of_turn>model\n";

        getBridge().execute(() -> {
            try {
                generateAndProcessStreaming(prompt);
            } catch (Exception e) {
                Log.e(TAG, "Inference streaming generation failed", e);
                call.reject("Failed to generate streaming response", e);
            }
        });

        call.resolve();
    }

    private void generateAndProcessStreaming(String prompt) throws IOException {
        LlmInference inference = getInference();
        UUID llmUuid = UUID.randomUUID();
        String id = llmUuid.toString();
        currentId = id;
        try {
            notifyListeners("llm_start", id);

            inference.generateResponseAsync(prompt);


            currentId = id;
            notifyListeners("llm_end", id);
        } catch (Exception e) {
            notifyListeners("llm_error", id, e.toString());
            Log.e(TAG, "Response error: ", e);
        }
    }

    private void notifyListeners(String eventName, String id) {
        notifyListeners(eventName, new JSObject().put("id", id), true);
    }

    private void notifyListeners(String eventName, String id, String value) {
        notifyListeners(eventName, new JSObject().put("id", id).put("value", value), true);
    }
}
