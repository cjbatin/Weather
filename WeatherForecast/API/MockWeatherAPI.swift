//
//  MockWeatherAPI.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

final class MockWeatherService: WeatherServiceProtocol {
    func getWeatherForCity(name: String, completion: @escaping ((Swift.Result<CurrentWeather, FetchError>) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let url = Bundle.main.url(forResource: "forecast", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let weather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    completion(.success(weather))
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        })
    }
    
    func getWeatherForCity(id: String, completion: @escaping ((Swift.Result<CurrentWeather, FetchError>) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let url = Bundle.main.url(forResource: "forecast", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let weather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    completion(.success(weather))
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        })
    }
    
    func getWeatherForCities(ids: [String], completion: @escaping ((Swift.Result<[CurrentWeather], FetchError>) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let url = Bundle.main.url(forResource: "multiCity_forecast", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let multiCity = try JSONDecoder().decode(MultiCity<CurrentWeather>.self, from: data)
                    completion(.success(multiCity.list))
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        })
    }
}
