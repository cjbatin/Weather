//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let main: MainWeather?
    let wind: Wind?
    let dt: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    let visibility: Int?
}
