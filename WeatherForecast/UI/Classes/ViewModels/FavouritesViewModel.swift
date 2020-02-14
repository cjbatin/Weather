//
//  FavouritesViewModel.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

protocol ViewControllerDelegate {
    func updateView()
    func presentError(_ message: String)
}
final class FavouritesViewModel {
    var weather = [CurrentWeather]() {
        didSet {
            delegate?.updateView()
        }
    }
    var addButtonEnabled: Bool {
        return weather.count < 20
    }
    var delegate: ViewControllerDelegate?
    func fetchData() {
        let ids = CoreDataStack.fetchIds()
        if !ids.isEmpty {
            if ids.count == 1 {
                fetchCity(id: ids[0])
            } else {
                fetchCities(ids: ids)
            }
        }
    }
    private func fetchCity(id: String) {
        WFService.shared.weatherService.getWeatherForCity(id: id,
                                                          completion: { result in
                                                            switch result {
                                                            case .success(let weather):
                                                                self.weather.append(weather)
                                                            case .failure(let error):
                                                                self.delegate?.presentError(error.localizedDescription)
                                                            }
        })
    }
    private func fetchCities(ids: [String]) {
        WFService.shared.weatherService.getWeatherForCities(ids: ids,
                                                            completion: { result in
            switch result {
            case .success(let weather):
                self.weather = weather
            case .failure(let error):
                self.delegate?.presentError(error.localizedDescription)
            }
        })
    }

    func handleAddCity(name: String) {
        WFService.shared.weatherService.getWeatherForCity(name: name,
                                                          completion: { result in
            switch result {
            case .success(let weather):
                let newLocation = Locations(context: CoreDataStack.context)
                newLocation.id = String(weather.id ?? 0)
                newLocation.name = weather.name ?? ""
                CoreDataStack.saveContext()
                self.weather.append(weather)
            case .failure(let error):
                self.delegate?.presentError(error.localizedDescription)
            }
        })
    }
}
