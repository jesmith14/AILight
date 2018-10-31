import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(QuickStartApp_iOSTests.allTests),
    ]
}
#endif