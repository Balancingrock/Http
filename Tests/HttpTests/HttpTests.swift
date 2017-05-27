import XCTest
@testable import Http

class HttpTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Http().text, "Hello, World!")
    }


    static var allTests : [(String, (HttpTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
