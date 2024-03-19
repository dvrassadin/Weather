//
//  OpenWeatherModel.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit
import OSLog
import CoreLocation

final class OpenWeatherModel: WeatherModelProtocol {
    
    // MARK: Properties
    private let networkService: NetworkServiceProtocol
    private(set) var weather: [Weather] = []
    private let imageCache = NSCache<NSString, UIImage>()
    private let geocoder = CLGeocoder()
    private let locationKey = "location"
    private(set) var location: String {
        didSet {
            UserDefaults.standard.setValue(location, forKey: locationKey)
            UserDefaults.standard.synchronize()
            logger.info("Set value \(self.location) to UserDefaults for key \"\(self.locationKey)\"")
        }
    }
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "\(#fileID)"
    )
    
    // MARK: Lifecycle
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        if let location = UserDefaults.standard.string(forKey: locationKey) {
            self.location = location
            logger.info("Received location from UserDefaults: \(location)")
        } else {
            location = "New York"
        }
    }
    
    // MARK: Updating data
    func updateWeather(location: String) async throws {
        let placemark = try await geocoder.geocodeAddressString(location)
        
        guard let placemark = placemark.first,
              let name = placemark.name,
              let coordinate = placemark.location?.coordinate
        else { throw APIError.invalidLocation }
        
        weather = try await networkService.requestForecast(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        self.location = name
    }
    
    func getWeatherIcon(at index: Int) async -> UIImage? {
        guard let iconName = weather[index].iconName else { return nil }
        if let image = imageCache.object(forKey: iconName as NSString) {
            logger.info("Received image from cache: \(iconName)")
            return image
        } else {
            guard let imageData = await networkService.requestWeatherIconData(iconName: iconName),
                  let image = UIImage(data: imageData) else { return nil }
            imageCache.setObject(image, forKey: iconName as NSString)
            return image
        }
    }
}
