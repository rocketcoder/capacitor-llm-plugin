import { WebPlugin } from '@capacitor/core';
import type { InferencePlugin } from './definitions';
export declare class InferenceWeb extends WebPlugin implements InferencePlugin {
    generate(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    generateStreaming(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}
