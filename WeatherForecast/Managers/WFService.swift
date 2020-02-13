//
//  WFService.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

final class WFService {
    static let shared = WFService()
    private init() { }

    private var shouldUseMocks: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    lazy var weatherService: WeatherServiceProtocol = {
        if shouldUseMocks {
            return MockWeatherService()
        } else {
            return WeatherService()
        }
    }()
}
