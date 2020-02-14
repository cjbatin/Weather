//
//  Date.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

extension Date {

    func formattedDate(_ format: String = "dd-MM-yyyy HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self).capitalized
    }
}
