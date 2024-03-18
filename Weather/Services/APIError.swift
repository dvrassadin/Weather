//
//  APIError.swift
//  Weather
//
//  Created by Daniil Rassadin on 15/3/24.
//

import Foundation

enum APIError: Error {
    case invalidServerURL
    case invalidAPIEndpoint
    case notHTTPResponse
    case unexpectedStatusCode
    case decodingError
    case emptyData
    case invalidLocation
}
