//
//  TestUtils.swift
//  WeatherForecastTests
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation
import XCTest

final class TestUtils {
    static func decodeJSON<T: Decodable>(_ filename: String) -> T? {
        if let url = Bundle(for: TestUtils.self).url(forResource: filename, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                XCTFail("Problem parsing JSON")
            }
        }
        XCTFail("Cannot find file")
        return nil
    }
}
