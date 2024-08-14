## Purpose
This capacitorjs plugin allows you to use on device llms like gemma-2b for inferencing.  This repo contains two projects.  
- A capacitorjs plugin that wraps MediaPipe and exposes the llm inferening capabilties.
- A capacitorjs react app that demos the usage of the plugin.

Currently the plugin is only available for iOS, Android is coming soon.

## Setup
The repo has two projects in it.  
An example capacitor app 
the plugin

The plugin is available on npm.

```bash
    npm install language-model-plugin
```

You may also wish to link the plugin via your local file ssystem if you are developing the plugin.  Add a reference to the plugin in your app in the packages.json.  (The reference is the folder where the plugin exists.)

```json
"language-model-plugin": "file:../language-model-plugin"
```

In the capacitor app (not the plugin) add a supported model to the copy bundle resources.
App, Target, Build Phases, Copy Build Resources, then add the model file.  You can download the model from kaggle.  https://www.kaggle.com/models/google/gemma/tfLite/gemma-2b-it-gpu-int4

## Usage
Here’s a simple example of how to use the plugin in your application:

```javascript
import { Inference } from 'language-model-plugin';
async function doInference(e){
        e.preventDefault();
        setMessageStream([]);
        const result = await Inference.generate({"value":promptRef.current.value});
        setLastMessage(result.value);
    }
```

The plugin also supports streaming responses:

```javascript
import { useState, useEffect, useRef } from 'react';
import { Inference } from 'language-model-plugin';

function AIModel() {

    const [messageStream, setMessageStream] = useState([]);
    const promptRef = useRef();

    async function doStreamingInference(e){
        e.preventDefault();
       await Inference.generateStreaming({"value":promptRef.current.value}); 
    }

    useEffect(() => {
        Inference.addListener("llm_partial",(result) => {
            console.log(result);
            setMessageStream(prevData => [...prevData, result.value]);  
        });
        Inference.addListener("llm_start",(result) => {
            console.log(result)
            setMessageStream([]);  
          });
    }, []);
    return (
        <>
            <input type="text" ref={promptRef}></input>
            <button onClick={doStreamingInference}>streaming inference</button>
            <span>{messageStream.join("")}</span>
        </>
    )
}

export default AIModel
```

More details coming soon...
