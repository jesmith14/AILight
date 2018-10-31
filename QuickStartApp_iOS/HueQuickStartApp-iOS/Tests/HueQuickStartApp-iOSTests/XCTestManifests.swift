import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HueQuickStartApp_iOSTests.allTests),
    ]
}
#endif