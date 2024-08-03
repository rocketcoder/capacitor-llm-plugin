import XCTest
@testable import InferencePlugin

class InferenceTests: XCTestCase {
    func testEcho() {
        // This is an example of a functional test case for a plugin.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let implementation = Inference()
        let value = "Hello, World!"
        let result = implementation.generate(value)

        XCTAssertEqual(value, result)
    }
}
