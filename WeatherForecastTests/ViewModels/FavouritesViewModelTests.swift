//
//  FavouritesViewModelTests.swift
//  WeatherForecastTests
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation
import XCTest
@testable import WeatherForecast

final class FavouritesViewModelTests: XCTestCase {
    var sut: FavouritesViewModel!

    override func setUp() {
        super.setUp()
        sut = FavouritesViewModel()
    }

    func testUpdateViewCalled() {
        let mockDelegate = MockViewControllerDelegate()
        sut.delegate = mockDelegate
        let exp = expectation(description: #function)
        sut.fetchCity(id: "2643743", { _ in
            XCTAssertTrue(mockDelegate.updateViewCalled)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
    }

    func testPresentErrorCalled_searchFails() {
        let mockDelegate = MockViewControllerDelegate()
        sut.delegate = mockDelegate
        let exp = expectation(description: #function)
        sut.handleAddCity(name: "", { _ in
            XCTAssertTrue(mockDelegate.presentErrorCalled)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
    }

    func testCanFetchCities() {
        let mockDelegate = MockViewControllerDelegate()
        sut.delegate = mockDelegate
        let exp = expectation(description: #function)
        sut.fetchCities(ids: ["524901","703448","2643743"], { _ in
            XCTAssertTrue(mockDelegate.updateViewCalled)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 5)
    }

    func testAddButtonDisabled() {
        let currentWeather = CurrentWeather(coord: nil, weather: nil, main: nil, wind: nil, dt: nil, id: 1, name: nil,
                                            cod: nil, visibility: nil)
        var i = 0
        while i < 20 {
            sut.weather.append(currentWeather)
            i += 1
        }
        XCTAssertFalse(sut.addButtonEnabled)
    }

    func testAddButtonEnabled() {
        let currentWeather = CurrentWeather(coord: nil, weather: nil, main: nil, wind: nil, dt: nil, id: 1, name: nil,
                                            cod: nil, visibility: nil)
        var i = 0
        while i <= 18 {
            sut.weather.append(currentWeather)
            i += 1
        }
        XCTAssertTrue(sut.addButtonEnabled)
    }
}


final class MockViewControllerDelegate: ViewControllerDelegate {
    var updateViewCalled = false
    var presentErrorCalled = false
    func updateView() {
        updateViewCalled = true
    }

    func presentError(_ message: String) {
        presentErrorCalled = true
    }
}
