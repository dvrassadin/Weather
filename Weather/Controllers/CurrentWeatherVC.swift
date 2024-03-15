//
//  CurrentWeatherVC.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

final class CurrentWeatherVC: UIViewController {
    
    // MARK: Properties
    private let currentWeatherView = CurrentWeatherView()
    private let model: WeatherModelProtocol

    // MARK: Lifecycle
    init(model: WeatherModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        updateWeather()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = currentWeatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Updating data
    func updateWeather() {
        Task(priority: .medium) {
            do {
                try await model.updateWeather()
                guard let weather = model.weather.first else { return }
                currentWeatherView.setWeather(weather: weather)
            } catch {
                print(error)
            }
        }
    }
}

