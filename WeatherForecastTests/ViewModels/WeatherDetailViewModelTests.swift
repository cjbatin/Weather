//
//  WeatherDetailViewModelTests.swift
//  WeatherForecastTests
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation
import XCTest
@testable import WeatherForecast
import SwiftUI

final class WeatherDetailViewModelTests: XCTestCase {

    var sut: WeatherDetailViewModel!

    override func setUp() {
        super.setUp()
        guard let currentWeather: CurrentWeather = TestUtils.decodeJSON("valid_current_weather") else {
            XCTFail("Failed to decode")
            return
        }
        let vm = WeatherDetailViewModel(currentWeather: currentWeather)
        sut = vm
    }

    func testTitle() {
        XCTAssertEqual(sut.name, "London")
    }

    func testWeather() {
        XCTAssertEqual(sut.weather, "Rain")
        XCTAssertEqual(sut.temp, "4.7 Celsius")
        XCTAssertEqual(sut.desc, "shower rain")
    }

    func testWind() {
        XCTAssertEqual(sut.directionAvailable, true)
        XCTAssertEqual(sut.direction, Angle.init(radians: 4.537856055185257))
        XCTAssertEqual(sut.speed, "Speed: 3.1m/s")
        XCTAssertEqual(sut.degrees, "Direction: 260.0m/s")
    }

    func testDate() {
        XCTAssertEqual(sut.formattedDate, "28-03-2018 20:21:19")
    }
}
