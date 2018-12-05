import XCTest
@testable import AILight

final class AILightTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AILight().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
