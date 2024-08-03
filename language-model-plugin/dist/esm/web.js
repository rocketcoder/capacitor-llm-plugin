import { WebPlugin } from '@capacitor/core';
export class InferenceWeb extends WebPlugin {
    async generate(options) {
        console.log('GENERATE', options);
        return options;
    }
    async generateStreaming(options) {
        console.log('GENERATE_STREAM', options);
        return options;
    }
}
//# sourceMappingURL=web.js.map