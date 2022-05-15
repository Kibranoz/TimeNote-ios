//
//  TimeNote_iosTests.swift
//  TimeNote iosTests
//
//  Created by Louis Couture on 2020-12-10.
//

import XCTest
@testable import TimeNote_ios

class TimeNote_iosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_givenAStringWhenAskingToTabAtSpecificPlaceThenAddTabToCorrectPlace() throws{
        var text = "Lorem ipsum dolor lorem ipsum";
        var txtUpdater = TextUpdater(text: text);
        var tabbedTxt = txtUpdater.insertAt(element: "    ", position: 0)
        XCTAssertEqual(tabbedTxt, "    Lorem ipsum dolor lorem ipsum")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
