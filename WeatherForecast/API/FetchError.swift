//
//  FetchError.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case error(String)

    var localizedDescription: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}
