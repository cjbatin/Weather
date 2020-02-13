//
//  FavouritesViewController.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import UIKit

final class FavouritesViewController: UIViewController {
    var weather = [CurrentWeather]() {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FavouriteLocationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "favouriteLocationsCell")
        tableView.dataSource = self
        fetchData()
    }

    private func fetchData() {
        WFService.shared.weatherService.getWeatherForCities(ids: ["524901","703448","2643743"],
                                                            completion: { result in
            switch result {
            case .success(let weather):
                self.weather = weather
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription,
                                              preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }
        })
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
                    self.weather.append(weather)
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription,
                                                  preferredStyle: .alert)
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
