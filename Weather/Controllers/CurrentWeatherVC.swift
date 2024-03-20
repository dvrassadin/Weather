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
    private var selectedIndex = 0

    // MARK: Lifecycle
    init(model: WeatherModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        currentWeatherView.delegate = self
        currentWeatherView.forecastCollectionView.dataSource = self
        currentWeatherView.forecastCollectionView.delegate = self
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
                currentWeatherView.setWeather(
                    weather: model.weatherByDays[selectedIndex],
                    location: model.location
                )
                selectedIndex = 0
                currentWeatherView.forecastCollectionView.reloadData()
                currentWeatherView.forecastCollectionView.selectItem(
                    at: IndexPath(row: selectedIndex, section: 0),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
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
    
    func getIcon(name: String) async -> UIImage? {
        return await model.getWeatherIcon(name: name)
    }
    
}

// MARK: - UICollectionViewDataSource
extension CurrentWeatherVC: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        model.weatherByDays.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ForecastCollectionViewCell.identifier,
            for: indexPath
        ) as? ForecastCollectionViewCell
        else { return ForecastCollectionViewCell() }
        
        let day = model.weatherByDays[indexPath.row]
        let averageWeather = day[day.count / 2]
        
        cell.setDate(averageWeather.date)
        if let iconName = averageWeather.iconName {
            Task(priority: .medium) {
                if let image = await model.getWeatherIcon(name: iconName) {
                    cell.setImage(image)
                }
            }
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension CurrentWeatherVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        currentWeatherView.setWeather(
            weather: model.weatherByDays[selectedIndex],
            location: model.location
        )
    }
    
}
