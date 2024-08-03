import Foundation

@objc public class Inference: NSObject {
    @objc public func generate(_ value: String) -> String {
        print(value)
        return value
    }
    @objc public func generateStreaming(_ value: String) async -> String {
        print(value)
        return value
    }
}
