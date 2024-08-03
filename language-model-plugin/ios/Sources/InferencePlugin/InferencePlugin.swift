import Foundation
import Capacitor
import MediaPipeTasksGenAI

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(InferencePlugin)
public class InferencePlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "InferencePlugin"
    public let jsName = "Inference"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "generate", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "generateStreaming", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = Inference()
    private var resourcePath = ""
    private var cachedInference: LlmInference?
    
    override public func load() {
        super.load()
        resourcePath = loadResource()
    }

    private func loadResource() -> String {
        guard let resourceUrl = Bundle.main.path(forResource: "gemma-2b-it-gpu-int4", ofType: "bin")  else {
            print("Resource not .found  Add the gemma-2b model to your app resources")
            return ""
        }
        return resourceUrl
    }

    private var inference: LlmInference
    {
      get throws {
        if let cached = cachedInference {
           return cached
        } else {
            let path = resourcePath
            print(path)
          let llmOptions = LlmInference.Options(modelPath: path)
          cachedInference = try LlmInference(options: llmOptions)
          return cachedInference!
        }
      }
    }

    @objc func generate(_ call: CAPPluginCall) {
        let inputPrompt = call.getString("value")!
        let prompt = """
        <start_of_turn>user
        \(inputPrompt)<end_of_turn>
        <start_of_turn>model
        """
        var result: String
        do {
            result = try inference.generateResponse(inputText: prompt)
        } catch {
            result = error.localizedDescription
        }
        call.resolve([
            "value": result
        ])
    }
    
    @objc func generateStreaming(_ call: CAPPluginCall) {
        let inputPrompt = call.getString("value") ?? ""
        let prompt = """
        <start_of_turn>user
        \(inputPrompt)<end_of_turn>
        <start_of_turn>model
        """
        
        Task{
            await generateAndProcessStreaming(prompt: prompt)
        }
        call.resolve([:])
    }
    
    func generateAndProcessStreaming(prompt: String) async {
        let llm_uuid = UUID()
        let id = llm_uuid.uuidString
        do {
            let resultStream =  try inference.generateResponseAsync(inputText: prompt)
            self.notifyListeners("llm_start", data: ["id":id])
            for try await partialResult in resultStream {
                self.notifyListeners("llm_partial", data: ["id":id, "value":partialResult])
            }
            self.notifyListeners("llm_end", data: ["id":id])
        }
        catch {
            self.notifyListeners("llm_error", data: ["id":id, "value":error])
            print("Response error: '\(error)")
        }   
    }
}
