var capacitorInference = (function (exports, core) {
    'use strict';

    const Inference = core.registerPlugin('Inference', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.InferenceWeb()),
    });

    class InferenceWeb extends core.WebPlugin {
        async generate(options) {
            console.log('GENERATE', options);
            return options;
        }
        async generateStreaming(options) {
            console.log('GENERATE_STREAM', options);
            return options;
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        InferenceWeb: InferenceWeb
    });

    exports.Inference = Inference;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
