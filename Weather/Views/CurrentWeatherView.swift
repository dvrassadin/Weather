//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit
import SwiftUI

// MARK: - CurrentWeatherView
final class CurrentWeatherView: UIView {
    
    // MARK: Properties
    weak var delegate: CurrentWeatherViewDelegate?
    
    // MARK: UI components
    private let locationPinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.locationPin)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Medium", size: 20)
        label.textColor = .white
        return label
    }()
    
    private let chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "chevron.down"
            )?.withTintColor(.white,renderingMode: .alwaysOriginal),for: .normal)
        return button
    }()
    
    private let cityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private let locationSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = String(localized: "Enter a City")
        searchBar.barTintColor = .customBackground2
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.font = UIFont(name: "Inter-Regular_Regular", size: 14)
        searchBar.textContentType = .addressCity
        searchBar.isHidden = true
        return searchBar
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Medium", size: 24)
        label.textColor = .white
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Medium", size: 64)
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Regular", size: 18)
        label.textColor = .white
        return label
    }()
    
    private let currentWeatherStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let chartView = ChartView()
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        setupUI()
        locationSearchBar.delegate = self
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .customBackground1
        addSubviews()
        setupConstraints()
        chevronButton.addTarget(
            self,
            action: #selector(toggleLocationSearchBar),
            for: .touchUpInside
        )
    }
    
    private func addSubviews() {
        cityStackView.addArrangedSubview(locationPinImageView)
        cityStackView.addArrangedSubview(cityNameLabel)
        cityStackView.addArrangedSubview(chevronButton)
        addSubview(cityStackView)
        addSubview(locationSearchBar)
        currentWeatherStackView.addArrangedSubview(descriptionLabel)
        currentWeatherStackView.addArrangedSubview(weatherIconImageView)
        currentWeatherStackView.addArrangedSubview(degreesLabel)
        currentWeatherStackView.addArrangedSubview(dateLabel)
        addSubview(currentWeatherStackView)
        addSubview(chartView)
    }
    
    private func setupConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cityStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 33),
            cityStackView.heightAnchor.constraint(equalToConstant: 28),
            
            locationSearchBar.topAnchor.constraint(equalTo: cityStackView.bottomAnchor, constant: 15),
            locationSearchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationSearchBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            locationSearchBar.heightAnchor.constraint(equalTo: cityStackView.heightAnchor),
            
            currentWeatherStackView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor, constant: 50),
            currentWeatherStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            weatherIconImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
            weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor),
            
            chartView.centerXAnchor.constraint(equalTo: centerXAnchor),
            chartView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.888),
            chartView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.305),
            chartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setWeather(weather: [Weather], location: String) {
        guard let firstWeather = weather.first else { return }
        
        setMainWeather(firstWeather, location: location)
        
        let todayForecast = weather.prefix(while: { weatherItem in
            Calendar.current.isDate(firstWeather.date, inSameDayAs: weatherItem.date)
        })
        dump(todayForecast)
        chartView.setChart(weather: Array(todayForecast))
        
        locationSearchBar.fadeOut(withDuration: 0.15)
        locationSearchBar.resignFirstResponder()
    }
    
    private func setMainWeather(_ weather: Weather, location: String) {
        cityNameLabel.text = location
        descriptionLabel.text = weather.description?.capitalized
        degreesLabel.text = "\(Int(weather.temperature.rounded()))°C"
        let day = weather.date.formatted(.dateTime.weekday(.wide))
        let date = weather.date.formatted(.dateTime.day().month().year())
        dateLabel.text = "\(day) | \(date)"
        Task(priority: .medium) {
            weatherIconImageView.image = await delegate?.getIcon(at: 1)
        }
    }
    
    // MARK: User interaction
    @objc private func toggleLocationSearchBar() {
        if locationSearchBar.isHidden {
            locationSearchBar.fadeIn(withDuration: 0.15)
            locationSearchBar.becomeFirstResponder()
        } else {
            locationSearchBar.fadeOut(withDuration: 0.15)
            locationSearchBar.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.phase == .began {
            locationSearchBar.fadeOut(withDuration: 0.15)
            endEditing(true)
        }
    }
}

// MARK: - SearchBarDelegate
extension CurrentWeatherView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        delegate?.updateLocation(text)
        searchBar.text = nil
    }
}
