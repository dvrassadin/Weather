//
//  NetworkServiceProtocol.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func requestForecast(latitude: Double, longitude: Double) async throws -> [Weather]
    func requestWeatherIconData(iconName: String) async -> Data?
}
