//
//  FavouritesViewController.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import UIKit
import CoreData
import SwiftUI

final class FavouritesViewController: UIViewController {
    let viewModel = FavouritesViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FavouriteLocationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "favouriteLocationsCell")
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
        viewModel.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorColor = .lightGray
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
            self.viewModel.handleAddCity(name: firstTextField.text ?? "")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(searchAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension FavouritesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.weather.isEmpty ? 0 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteLocationsCell") as? FavouriteLocationTableViewCell else {
            assertionFailure("Couldn't dequeue cell")
            return UITableViewCell(frame: .zero)
        }
        cell.configure(with: viewModel.weather[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedWeather = viewModel.weather[indexPath.row]
            viewModel.weather.remove(at: indexPath.row)
            CoreDataStack.delete(id: String(selectedWeather.id ?? 0))
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWeather = viewModel.weather[indexPath.row]
        if selectedWeather.id != nil {
            let detailsVM = WeatherDetailViewModel(currentWeather: selectedWeather)
            let weatherDetailView = WeatherDetailView(viewModel: detailsVM)
            navigationController?.pushViewController(UIHostingController(rootView: weatherDetailView),
                                                     animated: true)
        } else {
            presentError("Something went wrong sorry!")
        }
    }
}

extension FavouritesViewController: ViewControllerDelegate {
    func updateView() {
        tableView.reloadData()
        addButton.isEnabled = viewModel.addButtonEnabled
    }

    func presentError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
