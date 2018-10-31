import XCTest
@testable import HueQuickStartApp_iOS

final class HueQuickStartApp_iOSTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HueQuickStartApp_iOS().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
