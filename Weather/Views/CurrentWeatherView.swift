//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

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
        searchBar.placeholder = "Enter a City"
        searchBar.barTintColor = .customBackground
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
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        setupUI()
        locationSearchBar.delegate = self
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .customBackground
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cityStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cityStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 33),
            cityStackView.heightAnchor.constraint(equalToConstant: 28),
            
            locationSearchBar.topAnchor.constraint(equalTo: cityStackView.bottomAnchor, constant: 15),
            locationSearchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationSearchBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            locationSearchBar.heightAnchor.constraint(equalTo: cityStackView.heightAnchor),
            
            currentWeatherStackView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor, constant: 75),
            currentWeatherStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            weatherIconImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
            weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor)
        ])
    }
    
    func setWeather(weather: Weather, cityName: String) {
        cityNameLabel.text = cityName
        descriptionLabel.text = weather.description?.capitalized
        degreesLabel.text = "\(Int(weather.temperature.rounded()))°C"
        let day = weather.date.formatted(.dateTime.weekday(.wide))
        let date = weather.date.formatted(.dateTime.day().month().year())
        dateLabel.text = "\(day) | \(date)"
        locationSearchBar.fadeOut(withDuration: 0.2)
        locationSearchBar.resignFirstResponder()
    }
    
    func setWeatherImage(_ image: UIImage) {
        weatherIconImageView.image = image
    }
    
    // MARK: User interaction
    @objc private func toggleLocationSearchBar() {
        if locationSearchBar.isHidden {
            locationSearchBar.fadeIn(withDuration: 0.2)
            locationSearchBar.becomeFirstResponder()
        } else {
            locationSearchBar.fadeOut(withDuration: 0.2)
            locationSearchBar.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.phase == .began {
            locationSearchBar.fadeOut(withDuration: 0.2)
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
