import Foundation
import Capacitor


/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(InferencePlugin)
public class InferencePlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "InferencePlugin"
    public let jsName = "Inference"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "generate", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "generateStreaming", returnType: CAPPluginReturnPromise)
    ]
    // Change the model name to match the name of the model that you included in the appliction bundle
    private let modelName = "gemma-2b-it-gpu-int4"
    // Optional.  Change the adapter name to match the LoRA model that you included in the application bundle
    private let adapterName = ""
    
    private let ERROR_LLM_NOT_INIT = "LLM not initialized"
    
    //The paths to the model and adapter.  This is set in the load function. 
    private var implementation : Inference? = nil

    override public init() {
      super.init()
      
      let modelPath = self.getModelPath(name: modelName)
      var adapterPath:String?
      if adapterName.count > 1 {
        adapterPath = self.getAdapterPath(name: adapterName)
      }
      
      self.implementation = Inference(modelPath: modelPath, adapterPath: adapterPath, callback: streamingNotify)
    }
    
    //This function is called when the plugin is loaded
    override public func load() {
        super.load()
       
    }

    private func getModelPath(name : String) -> String {
        guard let modelUrl = Bundle.main.path(forResource: name, ofType: "bin")  else {
            print("Model not found.  Add the gemma-2b model to your app resources")
            return ""
        }
        
        return modelUrl
    }

    private func getAdapterPath(name :String) -> String {
        guard let adapterUrl = Bundle.main.path(forResource: name, ofType: "bin")  else {
            print("Adapter not found.  (Adapter is optional)  Add a LoRA adapter to your app resources see https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference/ios")
            return ""
        }
        return adapterUrl
    }
    
    func streamingNotify(eventName: String, data: [String:Any]?){
        self.notifyListeners(eventName, data: data, retainUntilConsumed: true)
    }
    
    @objc func generate(_ call: CAPPluginCall) {
        guard let llm = implementation else {
            call.resolve([
                "value": ERROR_LLM_NOT_INIT
            ])
            return
        }
        
        let inputPrompt = call.getString("value") ?? ""
        let result = llm.generate(inputPrompt)
        call.resolve([
            "value": result
        ])
    }
    
    @objc func generateStreaming(_ call: CAPPluginCall) {
        guard let llm = implementation else {
            let llm_uuid = UUID()
            let id = llm_uuid.uuidString
            self.streamingNotify(eventName: "llm_error", data: ["id":id, "value":ERROR_LLM_NOT_INIT])
            call.resolve([:])
            return
        }

        let inputPrompt = call.getString("value") ?? ""
        llm.generateStreaming(inputPrompt)
        call.resolve([:])
    }
}
