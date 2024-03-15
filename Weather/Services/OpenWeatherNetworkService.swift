//
//  OpenWeatherNetworkService.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import Foundation

final class OpenWeatherNetworkService: NetworkServiceProtocol {
    
    // MARK: Properties
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 15
        return session
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    // MARK: Requests
    func requestForecast() async throws -> [Weather] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/forecast")
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "42,85572"),
            URLQueryItem(name: "lon", value: "74,60116"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        guard let url = urlComponents.url else { throw APIError.invalidAPIEndpoint }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.notHTTPResponse
        }
        
        guard httpResponse.statusCode == 200 else { throw APIError.unexpectedStatusCode }
        
        do {
            return try decoder.decode(WeatherResponse.self, from: data).list
        } catch {
            throw APIError.decodingError
        }
    }
}
