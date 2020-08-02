//
//  Travel_WeatherTests.swift
//  Travel WeatherTests
//
//  Created by Renee Sajedian on 7/29/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import XCTest
import CoreData

@testable import Travel_Weather

class DayTests: XCTestCase {

    var day: Day!

    override func setUpWithError() throws {
        let managedObjectContext = CoreDataHelper.initializeInMemoryManagedObjectContext()
        //swiftlint:disable force_cast
        day = (NSEntityDescription.insertNewObject(forEntityName: "Day", into: managedObjectContext) as! Day)
    }

    override func tearDownWithError() throws {
        day = nil
    }

    func testHighTempDisplayIsAccurate() {
        //given
        day.highTemp = 98
        day.lowTemp = 2

        //then
        XCTAssertEqual(day.highTempDisplay, "98°")
    }

    func testMissingHighTempDisplayIsAccurate() {
        //given
        day.highTemp = nil
        day.lowTemp = 2

        //then
        XCTAssertEqual(day.highTempDisplay, "--- °")
        XCTAssertEqual(day.lowTempDisplay, "--- °")
    }

    func testMissingLowTempDisplayIsAccurate() {
        //given
        day.highTemp = 98
        day.lowTemp = nil

        //then
        XCTAssertEqual(day.highTempDisplay, "--- °")
        XCTAssertEqual(day.lowTempDisplay, "--- °")
    }

    func testLowTempDisplayIsAccurate() {
        //given
        day.lowTemp = 2
        day.highTemp = 98

        //then
        XCTAssertEqual(day.lowTempDisplay, "2°")
    }
}
