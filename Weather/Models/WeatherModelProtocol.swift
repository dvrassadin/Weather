//
//  WeatherModelProtocol.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

protocol WeatherModelProtocol {
    
    var weatherByDays: [[Weather]] { get }
    var location: String { get }
    
    func updateWeather(location: String) async throws
    func getWeatherIcon(name: String) async -> UIImage?
    
}
