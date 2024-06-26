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
    private(set) var weatherByDays: [[Weather]] = []
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
    private func getCoordinates(location: String) async throws -> CLLocationCoordinate2D {
        guard let placemark = try? await geocoder.geocodeAddressString(location).first,
              let name = placemark.name,
              let coordinate = placemark.location?.coordinate
        else { throw APIError.invalidLocation }
        
        self.location = name
        return coordinate
    }
    func updateWeather(location: String) async throws {
        let coordinate = try await getCoordinates(location: location)

        let weather = try await networkService.requestForecast(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        // Creating 2D array
        weatherByDays = Dictionary(grouping: weather) {
            $0.date.formatted(.dateTime.dayOfYear())
        }
        .sorted { $0.key < $1.key }
        .map { $0.value }
    }
    
    func getWeatherIcon(name: String) async -> UIImage? {
        if let image = imageCache.object(forKey: name as NSString) {
            logger.info("Received image from cache: \(name)")
            return image
        } else {
            guard let imageData = await networkService.requestWeatherIconData(iconName: name),
                  let image = UIImage(data: imageData) else { return nil }
            imageCache.setObject(image, forKey: name as NSString)
            return image
        }
    }
    
}
