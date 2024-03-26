//
//  OpenWeatherModelTests.swift
//  WeatherTests
//
//  Created by Daniil Rassadin on 26/3/24.
//

import XCTest
@testable import Weather

final class OpenWeatherModelTests: XCTestCase {
    private var networkService: NetworkServiceSpy!
    private var model: OpenWeatherModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = NetworkServiceSpy()
        model = OpenWeatherModel(networkService: networkService)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        networkService = nil
        model = nil
    }

    func testRequestForecastThrowingWithInvalidLocation() async {
        do {
            let _ = try await model.updateWeather(location: "fdsdfsdfsdfsdfsdf")
            XCTFail("The error wasn't thrown.")
        } catch {
            XCTAssertEqual(
                error as? APIError,
                APIError.invalidLocation,
                "An incorrect exception was thrown."
            )
        }
    }
    
    func testRequestForecastThrowingWithValidLocation() async {
        do {
            let _ = try await model.updateWeather(location: "New York")
        } catch {
            XCTAssertNotEqual(
                error as? APIError,
                APIError.invalidLocation,
                "The \"invalidLocation\" exception was thrown when the location is valid."
            )
        }
    }
    
    func testRequestForecastCallingWithValidLocation() async {
        do {
            let _ = try await model.updateWeather(location: "New York")
        } catch { }
        
        XCTAssertTrue(
            networkService.wasRequestForecastCalled,
            "The network service's requestForecast was not called when the location is valid."
        )
    }
    
    func testRequestForecastCallingWithInvalidLocation() async {
        do {
            let _ = try await model.updateWeather(location: "fdsdfsdfsdfsdfsdf")
        } catch { }
        
        XCTAssertFalse(
            networkService.wasRequestForecastCalled,
            "The network service's requestForecast was called when the location is invalid."
        )
    }
    
    func testRequestWeatherIconDataCalling() async {
        let _ = await networkService.requestWeatherIconData(iconName: "04n")
        XCTAssertTrue(networkService.wasRequestWeatherIconDataCalled, "The network service's requestWeatherIconData was not called")
    }
    
}
