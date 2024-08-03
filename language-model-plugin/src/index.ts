import { registerPlugin } from '@capacitor/core';

import type { InferencePlugin } from './definitions';

const Inference = registerPlugin<InferencePlugin>('Inference', {
  web: () => import('./web').then(m => new m.InferenceWeb()),
});

export * from './definitions';
export { Inference };
