//
//  Travel_WeatherTests.swift
//  Travel WeatherTests
//
//  Created by Renee Sajedian on 7/29/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import XCTest
@testable import Travel_Weather
@testable import JTAppleCalendar
@testable import GooglePlaces

class DayTests: XCTestCase {

    var day: Day!

    override func setUpWithError() throws {
        day = Day()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHighTempDisplayIsAccurate() {
        //given
        day.highTemp = 98

        //then
        XCTAssertEqual(day.highTempDisplay, "98°")
    }

    func testMissingHighTempDisplayIsAccurate() {
        //given
        day.highTemp = nil

        //then
        XCTAssertEqual(day.highTempDisplay, "--- °")
    }
    func testLowTempDisplayIsAccurate() {
        //given
        day.lowTemp = 2

        //then
        XCTAssertEqual(day.lowTempDisplay, "2°")

    }

}
