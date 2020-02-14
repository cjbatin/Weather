//
//  CurrentWeatherModelTests.swift
//  WeatherForecastTests
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation
import XCTest
@testable import WeatherForecast

final class CurrentWeatherForecastTests: XCTestCase {

    var sut: CurrentWeather!
    override func setUp() {
        super.setUp()
        sut = TestUtils.decodeJSON("valid_current_weather")
    }

    func testCanDecodeCurrentWeather() {
        XCTAssertEqual(sut.name, "London")
        XCTAssertEqual(sut.coord?.lat, 51.51)
        XCTAssertEqual(sut.coord?.lon, -0.13)
        XCTAssertEqual(sut.weather?[0].main, "Rain")
        XCTAssertEqual(sut.weather?[0].description, "shower rain")
        XCTAssertEqual(sut.main?.temp, 4.7)
        XCTAssertEqual(sut.wind?.deg, 260.0)
        XCTAssertEqual(sut.wind?.speed, 3.1)
        XCTAssertEqual(sut.dt, 1522264879)
        XCTAssertEqual(sut.id, 2643743)
        XCTAssertEqual(sut.cod, nil)
        XCTAssertEqual(sut.visibility, 10000)
    }
}
