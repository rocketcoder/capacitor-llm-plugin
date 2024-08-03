import { useState, useEffect, useRef } from 'react';
import { Inference } from 'language-model-plugin';

function AIModel() {

    const [lastMessage, setLastMessage] = useState("");
    const [messageStream, setMessageStream] = useState([]);
    const promptRef = useRef();

    async function doInference(e){
        e.preventDefault();
        setMessageStream([]);
        const result = await Inference.generate({"value":promptRef.current.value});
        setLastMessage(result.value);
    }

    async function doStreamingInference(e){
        e.preventDefault();
        setLastMessage("");
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
            <button onClick={doInference}>inference</button>
            <button onClick={doStreamingInference}>streaming inference</button>
            <p>{lastMessage}</p>
            
            <span>{messageStream.join("")}</span>
        </>
    )
}

export default AIModel