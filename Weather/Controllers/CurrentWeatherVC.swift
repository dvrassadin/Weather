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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWeather(locationName: model.location)
    }

    // MARK: Updating data
    func updateWeather(locationName: String) {
        Task(priority: .medium) {
            do {
                try await model.updateWeather(location: locationName)
                currentWeatherView.setWeather(weather: model.weather, location: model.location)
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
    
    func getIcon(at index: Int) async -> UIImage? {
        return await model.getWeatherIcon(at: index)
    }
}
