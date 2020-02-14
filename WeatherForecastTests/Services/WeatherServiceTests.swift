//
//  WeatherServiceTests.swift
//  WeatherForecastTests
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import XCTest
@testable import WeatherForecast

final class WeatherServiceTests: XCTestCase {
    var sut: WeatherService!
    override func setUp() {
        super.setUp()
        sut = WeatherService()
    }

    func testCanFetchCityByName() {
        let exp = expectation(description: #function)
        sut.getWeatherForCity(name: "London", completion: { result in
            XCTAssertTrue(Thread.isMainThread)
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.name, "London")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
    }

    func testCanFetchCityById() {
        let exp = expectation(description: #function)
        sut.getWeatherForCity(id: "2643743", completion: { result in
            XCTAssertTrue(Thread.isMainThread)
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.name, "London")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
    }

    func testCanFetchMultiCitiesByIds() {
        let exp = expectation(description: #function)
        sut.getWeatherForCities(ids: ["2643743", "524901"], completion: { result in
            XCTAssertTrue(Thread.isMainThread)
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather[0].name, "London")
                XCTAssertEqual(weather[1].name, "Moscow")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
    }
}
