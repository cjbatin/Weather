//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeatherForCity(name: String, completion: @escaping ((Swift.Result<CurrentWeather, FetchError>) -> Void))
    func getWeatherForCity(id: String, completion: @escaping ((Swift.Result<CurrentWeather, FetchError>) -> Void))
    func getWeatherForCities(ids: [String], completion: @escaping ((Swift.Result<[CurrentWeather], FetchError>) -> Void))
}

final class WeatherService: WeatherServiceProtocol {
    private let uri = "https://api.openweathermap.org/data/2.5/weather?APPID=62738a62f4b83eca1f6dbcf4409f2664"


    func getWeatherForCity(name: String, completion: @escaping ((Swift.Result<CurrentWeather, FetchError>) -> Void)) {
        let fullURI = "\(uri)&q=\(name)"
        let request = APIRequester.shared.createRequest(uri: fullURI)
        APIRequester.shared.dataTask(urlRequest: request, { (result: Swift.Result<CurrentWeather, FetchError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }).resume()
    }

    func getWeatherForCity(id: String, completion: @escaping ((Swift.Result<CurrentWeather, FetchError>) -> Void)) {
        let fullURI = "\(uri)&id=\(id)"
        let request = APIRequester.shared.createRequest(uri: fullURI)
        APIRequester.shared.dataTask(urlRequest: request, { (result: Swift.Result<CurrentWeather, FetchError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }).resume()
    }

    func getWeatherForCities(ids: [String], completion: @escaping ((Swift.Result<[CurrentWeather], FetchError>) -> Void)) {
        var fullURI = "\(uri)&id="
        for id in ids {
            fullURI.append(id)
            fullURI.append(",")
        }
        fullURI.removeLast()
        let request = APIRequester.shared.createRequest(uri: fullURI)
        APIRequester.shared.dataTask(urlRequest: request, { (result: Swift.Result<MultiCity<CurrentWeather>, FetchError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let multiCity):
                    completion(.success(multiCity.list))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }).resume()
    }
}
