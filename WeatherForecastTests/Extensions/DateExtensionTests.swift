//
//  DateExtensionTests.swift
//  WeatherForecastTests
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import XCTest
@testable import WeatherForecast

final class DateExtensionTests: XCTestCase {
    let date = Date.init(timeIntervalSince1970: 1522264879)

    func testCanFormatDateCorrectly() {
        XCTAssertEqual(date.formattedDate(), "28-03-2018 20:21:19")
    }
}
