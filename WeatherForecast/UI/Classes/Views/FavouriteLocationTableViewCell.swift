//
//  FavouriteLocationTableViewCell.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import UIKit

final class FavouriteLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var northLabel: UILabel!
    func configure(with currentWeather: CurrentWeather) {
        nameLabel.text = currentWeather.name
        setWindInformation(wind: currentWeather.wind)
    }

    func setWindInformation(wind: Wind?) {
        guard let wind = wind else {
            speedLabel.text = "Speed Not Available"
            directionLabel.text = "Direction Not Available"
            windImageView.isHidden = true
            northLabel.isHidden = true
            return
        }
        if let speed = wind.speed {
            speedLabel.text = "Speed: \(speed)m/s"
        } else {
            speedLabel.text = "Speed Not Available"
        }
        if let direction = wind.deg {
            windImageView.isHidden = false
            northLabel.isHidden = false
            directionLabel.text = "Direction: \(direction) deg"
            let directionAsFloat = CGFloat(direction)
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.0, animations: {
                    self.windImageView.transform = CGAffineTransform(rotationAngle: directionAsFloat.degreesToRadians())
                })
            }
        } else {
            directionLabel.text = "Direction Not Available"
            windImageView.isHidden = true
            northLabel.isHidden = true
        }
    }
}
