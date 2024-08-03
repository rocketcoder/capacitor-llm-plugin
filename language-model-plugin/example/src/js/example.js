import { Inference } from 'languague-model-plugin';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    Inference.echo({ value: inputValue })
}
