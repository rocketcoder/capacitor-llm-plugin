import Foundation
import MediaPipeTasksGenAI


@objc public class Inference: NSObject {

    //The path to load 
    private var modelPath: String
    private var adapterPath: String
    private var cachedInference: LlmInference?
    public typealias NotifyHandler = (String, [String:Any]?) -> Void
    private var notifyHandler: NotifyHandler?

    

    public init(modelPath: String, adapterPath: String? = nil, callback: NotifyHandler? ) {
        self.modelPath = modelPath
        self.adapterPath = adapterPath ?? ""
        self.notifyHandler = callback
    }

    private var inference: LlmInference
    {
      get throws {
        if let cached = cachedInference {
           return cached
        } else {      
            let llmOptions = LlmInference.Options(modelPath: modelPath)
            if adapterPath.count > 1 {
                llmOptions.loraPath = self.adapterPath
            }
            cachedInference = try LlmInference(options: llmOptions)
            return cachedInference!
        }
      }
    }

    @objc public func generate(_ inputPrompt: String) -> String {
        let prompt = """
        <start_of_turn>user
        \(inputPrompt)<end_of_turn>
        <start_of_turn>model
        """
        var result: String
        do {
            result = try inference.generateResponse(inputText: prompt)
        } catch {
            result = error.localizedDescription
        }
        return result
    }
    @objc public func generateStreaming(_ inputPrompt: String) {
        let prompt = """
        <start_of_turn>user
        \(inputPrompt)<end_of_turn>
        <start_of_turn>model
        """
        
        Task{
            await generateAndProcessStreaming(prompt: prompt)
        }
    }

    func generateAndProcessStreaming(prompt: String) async {
        let llm_uuid = UUID()
        let id = llm_uuid.uuidString
        guard let callback = self.notifyHandler else {
            return
        }
        
        do {
            let resultStream =  try inference.generateResponseAsync(inputText: prompt)
            callback("llm_start", ["id":id])
            for try await partialResult in resultStream {
                callback("llm_partial", ["id":id, "value":partialResult])
            }
            callback("llm_end", ["id":id])
        }
        catch {
            callback("llm_error", ["id":id, "value":error])
            print("Response error: '\(error)")
        }   
    }
}
