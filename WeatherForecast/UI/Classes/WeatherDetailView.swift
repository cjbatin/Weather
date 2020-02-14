//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import SwiftUI

struct WeatherDetailView: View {
    let currentWeather: CurrentWeather
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().tableFooterView = UIView()
    }
    var body: some View {
        List {
            Section(header: Text("Wind")) {
                HStack {
                    if directionAvailable {
                        VStack {
                            Text("N")
                            Image("WindDirection").rotationEffect(direction)
                        }
                    } else {
                        Text("Wind Direction not available")
                    }
                    VStack {
                        Text("Speed: \(currentWeather.wind?.speed ?? 0.0)m/s")
                        Text("Direction: \(currentWeather.wind?.deg ?? 0.0)")
                    }
                    Spacer()
                }
            }
            Section(header: Text("Weather")) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(currentWeather.weather?.first?.main ?? "")")
                        Spacer()
                        Text("\(currentWeather.main?.temp ?? 0.0) Celsius")
                        Spacer()
                    }
                    HStack {
                        Text("\(currentWeather.weather?.first?.description ?? "")")
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitle(Text(currentWeather.name ?? ""))
    }

    var directionAvailable: Bool {
        return currentWeather.wind?.deg != nil
    }
    var direction: Angle {
        Angle(degrees: currentWeather.wind?.deg ?? 0.0)
    }


}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let coord = Coord(lon: 5, lat: 5)
        let weather = Weather(id: 1, main: "Drizzle",
                              description: "light intensity drizzle",
                              icon: nil)
        let mainWeather = MainWeather(temp: 22.2)
        let wind = Wind(speed: 4.1, deg: 80.0)
        return WeatherDetailView(currentWeather: CurrentWeather(coord: coord,
                                                                weather: [weather],
                                                                main: mainWeather,
                                                                wind: wind,
                                                                dt: 1485789600,
                                                                id: 2643743,
                                                                name: "London",
                                                                cod: 200,
                                                                visibility: 10000))
    }
}
