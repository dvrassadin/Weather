//
//  WeatherModelProtocol.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

protocol WeatherModelProtocol {
    var weather: [Weather] { get }
    
    func updateWeather() async throws
    func getWeatherIcon(at index: Int) async throws -> UIImage?
}
