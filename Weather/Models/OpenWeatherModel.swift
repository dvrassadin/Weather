//
//  OpenWeatherModel.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

final class OpenWeatherModel: WeatherModelProtocol {
    
    // MARK: Properties
    private let networkService: NetworkServiceProtocol
    private(set) var weather: [Weather] = []
    private var iconsCache: [String: UIImage] = [:]
    
    // MARK: Lifecycle
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Updating data
    func updateWeather() async throws {
        weather = try await networkService.requestForecast()
    }
}
