//
//  WeatherModelProtocol.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import Foundation

protocol WeatherModelProtocol {
    var weather: [Weather] { get }
    
    func updateWeather() async throws
}
