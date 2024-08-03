import { WebPlugin } from '@capacitor/core';

import type { InferencePlugin } from './definitions';

export class InferenceWeb extends WebPlugin implements InferencePlugin {
  async generate(options: { value: string }): Promise<{ value: string }> {
    console.log('GENERATE', options);
    return options;
  }
  async generateStreaming(options: { value: string }): Promise<{ value: string }> {
    console.log('GENERATE_STREAM', options);
    return options;
  }
}
