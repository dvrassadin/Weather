//
//  WeatherResponse.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

struct WeatherResponse: Decodable {
    let list: [Weather]
}

struct Weather: Decodable {
    let date: Date
    var temperature: Double { main.temp }
    var feelsLike: Double { main.feelsLike }
    var description: String? { weather.first?.description }
    var windSpeed: Double { wind.speed }
    var iconName: String? { weather.first?.icon }
    
    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main, weather, wind
    }
    
    private let main: Main
    private struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
    }
    
    private let weather: [WeatherType]
    private struct WeatherType: Decodable {
        let description: String
        let icon: String
    }
    
    private let wind: Wind
    private struct Wind: Decodable {
        let speed: Double
    }
}

