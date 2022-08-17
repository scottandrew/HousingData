//
//  HousingDataTests.swift
//  HousingDataTests
//
//  Created by Scott Andrew on 8/2/22.
//

import XCTest
@testable import HousingData

final class RegionDataParserTests: XCTestCase {

    func testParser() async throws {
        guard let url = Bundle(for: RegionDataParserTests.self).url(forResource: "TestData", withExtension: "csv") else {
            XCTFail("Can't find test files")
            return
        }
        
        let data = try await RegionDataParser().parse(url: url)
        let calendar = Calendar(identifier: .gregorian)
        
        XCTAssert(data.count == 908)
        
        // lets verify a few rows..
        let usaRegion = data[0];
        
        XCTAssertEqual(usaRegion.id, 102001)
        XCTAssertEqual(usaRegion.name, "United States")
        XCTAssertEqual(usaRegion.type, .country)
        XCTAssertEqual(usaRegion.rank, 0)
        XCTAssertNil(usaRegion.state)
        
        XCTAssertEqual(usaRegion.values.count, 270)
        
        var components = DateComponents( year: 2000, month: 1, day: 31)
        XCTAssertEqual(usaRegion.values[0].value, 128825.0)
        XCTAssertEqual(usaRegion.values[0].date, calendar.date(from: components))
        
        components = DateComponents( year: 2022, month: 6, day: 30)
        XCTAssertEqual(usaRegion.values[269].value, 354649.0)
        XCTAssertEqual(usaRegion.values[269].date, calendar.date(from: components))
        
        // Indianapolis has null data columns.
        let indianapolisRegion = data[33];
        
        XCTAssertEqual(indianapolisRegion.id, 394705)
        XCTAssertEqual(indianapolisRegion.name, "Indianapolis, IN")
        XCTAssertEqual(indianapolisRegion.type, .metro)
        XCTAssertEqual(indianapolisRegion.rank, 33)
        XCTAssertEqual(indianapolisRegion.state, "IN")
        
        XCTAssertEqual(indianapolisRegion.values.count, 270)
        
        components = DateComponents( year: 2000, month: 1, day: 31)
        XCTAssertNil(indianapolisRegion.values[0].value)
        XCTAssertEqual(indianapolisRegion.values[0].date, calendar.date(from: components))
        
        components = DateComponents( year: 2022, month: 6, day: 30)
        XCTAssertEqual(indianapolisRegion.values[269].value, 273964)
        XCTAssertEqual(indianapolisRegion.values[269].date, calendar.date(from: components))
    }
}
