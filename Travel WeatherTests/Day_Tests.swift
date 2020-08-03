//
//  Day_Tests.swift
//  Travel WeatherTests
//
//  Created by Renee Sajedian on 8/3/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import XCTest
import CoreData
import Foundation

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

    func testHighTempDisplayFahrenheitIsAccurate() {
        //given
        day.highTemp = 98
        day.lowTemp = 2

        //then
        XCTAssertEqual(day.highTempDisplayFahrenheit, "98°")
    }

    func testLowTempDisplayFahrenheitIsAccurate() {
        //given
        day.lowTemp = 2
        day.highTemp = 98

        //then
        XCTAssertEqual(day.lowTempDisplayFahrenheit, "2°")
    }

    func testHighTempDisplayCelsiusIsAccurate() {
        //given
        day.highTemp = 98
        day.lowTemp = 2

        //then
        XCTAssertEqual(day.highTempDisplayCelsius, "37°")
    }

    func testLowTempDisplayCelsiusIsAccurate() {
        //given
        day.lowTemp = 2
        day.highTemp = 98

        //then
        XCTAssertEqual(day.lowTempDisplayCelsius, "-17°")
    }

    func testMissingHighTempDisplayIsAccurate() {
        //given
        day.highTemp = nil
        day.lowTemp = 2

        //then
        XCTAssertEqual(day.highTempDisplayFahrenheit, "--- °")
        XCTAssertEqual(day.lowTempDisplayFahrenheit, "--- °")
        XCTAssertEqual(day.highTempDisplayCelsius, "--- °")
        XCTAssertEqual(day.lowTempDisplayCelsius, "--- °")
    }

    func testMissingLowTempDisplayIsAccurate() {
        //given
        day.highTemp = 98
        day.lowTemp = nil

        //then
        XCTAssertEqual(day.highTempDisplayFahrenheit, "--- °")
        XCTAssertEqual(day.lowTempDisplayFahrenheit, "--- °")
        XCTAssertEqual(day.highTempDisplayCelsius, "--- °")
        XCTAssertEqual(day.lowTempDisplayCelsius, "--- °")

    }

    func testWeekdayIsCorrect() {
        //given
        let calendar = Calendar.current
        let components = DateComponents(calendar: Calendar.current, year: 2020, month: 8, day: 2)
        day.date = calendar.date(from: components)!

        //then
        XCTAssertEqual(day.weekday, "Sunday")
    }
}
