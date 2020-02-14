//
//  CGFloatExtensionTests.swift
//  WeatherForecastTests
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import XCTest
@testable import WeatherForecast

final class CGFloatExtensionSpecs: XCTestCase {

    var sut: CGFloat!

    func testCanConvertDegreesToRadians() {
        sut = 222.0
        XCTAssertEqual(sut.degreesToRadians(), 3.8746309394274117)
    }
}
