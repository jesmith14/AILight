import XCTest
@testable import QuickStartApp_iOS

final class QuickStartApp_iOSTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(QuickStartApp_iOS().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
