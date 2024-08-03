import { registerPlugin } from '@capacitor/core';
const Inference = registerPlugin('Inference', {
    web: () => import('./web').then(m => new m.InferenceWeb()),
});
export * from './definitions';
export { Inference };
//# sourceMappingURL=index.js.map