export interface InferencePlugin {
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
