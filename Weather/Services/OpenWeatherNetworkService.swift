//
//  OpenWeatherNetworkService.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import OSLog

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
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "\(#fileID)"
    )
    
    private let baseURL = "https://api.openweathermap.org"
    
    // MARK: Requests
    func requestForecast(latitude: Double, longitude: Double) async throws -> [Weather] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/data/2.5/forecast")
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        do {
            let weather = try decoder.decode(WeatherResponse.self, from: data).list
            guard !weather.isEmpty else {
                logger.notice("Empty data received for latitude and longitude: \(latitude), \(longitude)")
                throw APIError.emptyData
            }
            logger.info("Received \(weather.count) weather items for request: \(url.absoluteString)")
            return weather
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)")
            throw APIError.decodingError
        }
    }
    
    func requestWeatherIconData(iconName: String) async -> Data? {
        guard var urlComponents = URLComponents(string: "https://openweathermap.org/img/wn") else {
            logger.error("Invalid server URL: \(self.baseURL)")
            return nil
        }
        
        urlComponents.path.append("/\(iconName)@4x.png")
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            return nil
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        logger.info("Starting request: \(url.absoluteString)")
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("API response is not HTTP response")
                return nil
            }
            
            guard httpResponse.statusCode == 200 else {
                logger.error("Unexpected status code: \(httpResponse.statusCode)")
                return nil
            }
            
            guard !data.isEmpty else {
                logger.notice("Empty data received")
                return nil
            }
            
            logger.info("Received image data for request: \(request)")
            return data
        } catch {
            logger.error("\(error)")
            return nil
        }
    }
}
