//
//  CurrentWeatherVC.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

// MARK: - CurrentWeatherVC
final class CurrentWeatherVC: UIViewController {
    
    // MARK: Properties
    private let currentWeatherView = CurrentWeatherView()
    private let model: WeatherModelProtocol

    // MARK: Lifecycle
    init(model: WeatherModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        currentWeatherView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = currentWeatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeather(locationName: model.location)
    }

    // MARK: Updating data
    func updateWeather(locationName: String) {
        Task(priority: .medium) {
            do {
                try await model.updateWeather(location: locationName)
                guard let weather = model.weather.first else { return }
                currentWeatherView.setWeather(weather: weather, cityName: model.location)
                guard let image = try await model.getWeatherIcon(at: 0) else { return }
                currentWeatherView.setWeatherImage(image)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - CurrentWeatherViewDelegate
extension CurrentWeatherVC: CurrentWeatherViewDelegate {
    func updateLocation(_ location: String) {
        updateWeather(locationName: location)
    }
}
