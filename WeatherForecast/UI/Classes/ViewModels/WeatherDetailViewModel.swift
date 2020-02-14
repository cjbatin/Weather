//
//  WeatherDetailViewModel.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import SwiftUI

final class WeatherDetailViewModel {
    let currentWeather: CurrentWeather

    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    var name: String {
        return currentWeather.name ?? ""
    }
    var directionAvailable: Bool {
        return currentWeather.wind?.deg != nil
    }
    var direction: Angle {
        Angle(degrees: currentWeather.wind?.deg ?? 0.0)
    }

    var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(currentWeather.dt ?? 0))
        return date.formattedDate()
    }

    var speed: String {
        if let speed = currentWeather.wind?.speed {
            return "Speed: \(speed)m/s"
        }
        return "No Speed Available"
    }

    var degrees: String {
        if let degrees = currentWeather.wind?.deg {
            return "Direction: \(degrees)m/s"
        }
        return "No Direction Available"
    }

    var weather: String {
        if let weather = currentWeather.weather?.first?.main {
            return "\(weather)"
        }
        return "No Weather Available"
    }

    var temp: String {
        if let temp = currentWeather.main?.temp {
            return "\(temp) Celsius"
        }
        return "No Temperature Available"
    }

    var desc: String {
        if let desc = currentWeather.weather?.first?.description {
            return "\(desc)"
        }
        return "No Weather Available"
    }
}
