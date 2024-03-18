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
    private let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: Lifecycle
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Updating data
    func updateWeather() async throws {
        weather = try await networkService.requestForecast(latitude: 42.85572, longitude: 74.60116)
    }
    
    func getWeatherIcon(at index: Int) async throws -> UIImage? {
        guard let iconName = weather[index].iconName else { return nil }
        if let image = imageCache.object(forKey: iconName as NSString) {
            print("Using cache for image \(iconName)")
            return image
        } else {
            let imageData = try await networkService.requestWeatherIconData(iconName: iconName)
            guard let image = UIImage(data: imageData) else { return nil }
            imageCache.setObject(image, forKey: iconName as NSString)
            return image
        }
    }
}
