//
//  FavouritesViewController.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import UIKit
import CoreData

final class FavouritesViewController: UIViewController {
    var weather = [CurrentWeather]() {
        didSet {
            tableView.reloadData()
            if weather.count >= 20 {
                addButton.isEnabled = false
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FavouriteLocationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "favouriteLocationsCell")
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }

    private func fetchData() {
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
                                                                self.presentError(error)
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
                self.presentError(error)
            }
        })
    }
    private func presentError(_ error: FetchError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Location", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "City Name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let searchAction = UIAlertAction(title: "Search", style: .default, handler: { alert -> Void in
            guard let firstTextField = alertController.textFields?.first else {
                assertionFailure("Should have text field")
                return
            }
            WFService.shared.weatherService.getWeatherForCity(name: firstTextField.text ?? "",
                                                              completion: { result in
                switch result {
                case .success(let weather):
                    let newLocation = Locations(context: CoreDataStack.context)
                    newLocation.id = String(weather.id ?? 0)
                    newLocation.name = weather.name ?? ""
                    CoreDataStack.saveContext()
                    self.weather.append(weather)
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(searchAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension FavouritesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return weather.isEmpty ? 0 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteLocationsCell") as? FavouriteLocationTableViewCell else {
            assertionFailure("Couldn't dequeue cell")
            return UITableViewCell(frame: .zero)
        }
        cell.configure(with: weather[indexPath.row])
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedWeather = weather[indexPath.row]
            weather.remove(at: indexPath.row)
            CoreDataStack.delete(id: String(selectedWeather.id ?? 0))
        }
    }
}
