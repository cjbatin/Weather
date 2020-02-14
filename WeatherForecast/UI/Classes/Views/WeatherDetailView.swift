//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 14/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import SwiftUI

struct WeatherDetailView: View {
    let viewModel: WeatherDetailViewModel
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().tableFooterView = UIView()
    }
    var body: some View {
        List {
            HStack {
                Spacer()
                Text(viewModel.formattedDate)
                Spacer()
            }.padding()
            Section(header: Text("Wind")) {
                HStack {
                    if viewModel.directionAvailable {
                        VStack {
                            Text("N")
                            Image("WindDirection").rotationEffect(viewModel.direction)
                        }
                    } else {
                        Text("Wind Direction not available")
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(viewModel.speed)
                        Text(viewModel.degrees)
                    }
                    Spacer()
                }.padding()
            }
            Section(header: Text("Weather")) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(viewModel.weather)")
                        Spacer()
                        Text("\(viewModel.temp)")
                        Spacer()
                    }
                    HStack {
                        Text("\(viewModel.desc)")
                        Spacer()
                    }
                }.padding()
            }
        }
        .navigationBarTitle(Text(viewModel.name))
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
        let vm = WeatherDetailViewModel(currentWeather: CurrentWeather(coord: coord,
                                                                       weather: [weather],
                                                                       main: mainWeather,
                                                                       wind: wind,
                                                                       dt: 1485789600,
                                                                       id: 2643743,
                                                                       name: "London",
                                                                       cod: 200,
                                                                       visibility: 10000))
        return WeatherDetailView(viewModel: vm)
    }
}
