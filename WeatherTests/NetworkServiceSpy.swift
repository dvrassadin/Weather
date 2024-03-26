//
//  NetworkServiceSpy.swift
//  WeatherTests
//
//  Created by Daniil Rassadin on 26/3/24.
//

import XCTest
@testable import Weather

final class NetworkServiceSpy: NetworkServiceProtocol {
    private(set) var wasRequestForecastCalled = false
    private(set) var wasRequestWeatherIconDataCalled = false
    
    func requestForecast(latitude: Double, longitude: Double) async throws -> [Weather] {
        wasRequestForecastCalled = true
        return []
    }
    
    func requestWeatherIconData(iconName: String) async -> Data? {
        wasRequestWeatherIconDataCalled = true
        return nil
    }
}
