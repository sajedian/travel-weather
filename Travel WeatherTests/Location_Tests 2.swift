//
//  Location_Tests.swift
//  Travel WeatherTests
//
//  Created by Renee Sajedian on 8/3/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import XCTest
import CoreData

@testable import Travel_Weather

//swiftlint:disable type_name
class Location_Tests: XCTestCase {

    var location: Location!

    override func setUpWithError() throws {
        let managedObjectContext = CoreDataHelper.initializeInMemoryManagedObjectContext()
        //swiftlint:disable force_cast
        location = (NSEntityDescription.insertNewObject(forEntityName: "Location",
                                                        into: managedObjectContext) as! Location)
    }

    override func tearDownWithError() throws {
        location = nil
    }

    func testLocationDisplayUS() {
        //given
        location.country = "United States"
        location.shortState = "MA"
        location.locality = "Cambridge"

        //then
        XCTAssertEqual(location.display, "Cambridge, MA, US")
    }

    func testLocationDisplayUSNoState() {
        //given
        location.country = "United States"
        location.locality = "Cambridge"

        //then
        XCTAssertEqual(location.display, "Cambridge, US")
    }

    func testLocationDisplayCanada() {
        //given
        location.country = "Canada"
        location.locality = "Montreal"
        location.shortState = "QC"

        XCTAssertEqual(location.display, "Montreal, QC, Canada")
    }

    func testLocationDisplayCanadaNoState() {
        //given
        location.country = "Canada"
        location.locality = "Montreal"

        XCTAssertEqual(location.display, "Montreal, Canada")
    }

    func testLocationDisplayMexico() {
        //given
        location.country = "Mexico"
        location.locality = "Cancun"
        location.shortState = "QR"

        XCTAssertEqual(location.display, "Cancun, QR, Mexico")
    }

    func testLocationDisplayMexicoNoState() {
        //given
        location.country = "Mexico"
        location.locality = "Cancun"

        XCTAssertEqual(location.display, "Cancun, Mexico")
    }

    func testLocationDisplayAustralia() {
        //given
        location.country = "Australia"
        location.shortState = "NSW"
        location.locality = "Sydney"

        XCTAssertEqual(location.display, "Sydney, NSW, Australia")
    }

    func testLocationDisplayAustraliaNoState() {
        //given
        location.country = "Australia"
        location.locality = "Sydney"

        XCTAssertEqual(location.display, "Sydney, Australia")
    }

    func testLocationDisplayOtherCountry() {
        //given
        location.country = "Spain"
        location.locality = "Barcelona"

        XCTAssertEqual(location.display, "Barcelona, Spain")
    }

    func testLocationDisplayNoCountry() {
        location.locality = "Vatican City"

        XCTAssertEqual(location.display, "Vatican City")
    }

}
