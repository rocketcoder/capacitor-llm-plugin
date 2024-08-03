package com.educatorai.language_model_plugin;

import android.util.Log;

public class Inference {

    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }
}
