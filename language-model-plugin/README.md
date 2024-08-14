# language-model-plugin

Enabled on device inferencing using Mediapipe LLM.

## Install

```bash
npm install language-model-plugin
npx cap sync
```

## API

<docgen-index>

* [`generate(...)`](#generate)
* [`generateStreaming(...)`](#generatestreaming)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### generate(...)

```typescript
generate(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### generateStreaming(...)

```typescript
generateStreaming(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------

</docgen-api>

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
