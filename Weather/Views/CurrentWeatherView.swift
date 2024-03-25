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
    private var isHorizontalRegular: Bool {
        window?.windowScene?.screen.traitCollection.horizontalSizeClass == .regular
    }
    private var isVerticalRegular: Bool {
        window?.windowScene?.screen.traitCollection.verticalSizeClass == .regular
    }
    private var isLandscape: Bool { UIDevice.current.orientation.isLandscape }
    
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
        searchBar.textContentType = .addressCity
        searchBar.isHidden = true
        return searchBar
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let forecastCollectionView = ForecastCollectionView()
    
    let chartView = ChartView()
    
    private lazy var detailsView = DetailsView(forecastCollectionView: forecastCollectionView)
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        forecastCollectionView.register(
            ForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier
        )
        locationSearchBar.delegate = self
        chartView.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layoutForSizes()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .customBackground1
        addSubviews()
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
        addSubview(descriptionLabel)
        addSubview(weatherIconImageView)
        addSubview(degreesLabel)
        addSubview(dateLabel)
        addSubview(chartView)
    }
    
    // MARK: Constraints
    private lazy var sharedConstraints: [NSLayoutConstraint] = [
        cityStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
        cityStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 33),
        cityStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.03),
        
        locationSearchBar.topAnchor.constraint(equalTo: cityStackView.bottomAnchor, constant: 5),
        locationSearchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
        locationSearchBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
        locationSearchBar.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.031),
        
        descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: locationSearchBar.bottomAnchor),
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        
        weatherIconImageView.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 1),
        weatherIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        weatherIconImageView.widthAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.31),
        weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor),
        weatherIconImageView.bottomAnchor.constraint(greaterThanOrEqualTo: degreesLabel.topAnchor, constant: -1),
        
        degreesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        degreesLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -5),
        
        dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: forecastCollectionView.topAnchor, constant: -15),
        
        forecastCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
        forecastCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
        forecastCollectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.849),
        forecastCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: chartView.topAnchor, constant: -10),
        
        chartView.centerXAnchor.constraint(equalTo: centerXAnchor),
        chartView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.888),
        chartView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.304),
        chartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ]
    
    private lazy var regularConstraints: [NSLayoutConstraint] = [
        cityStackView.topAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        cityStackView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
        cityStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.031),
        
        locationSearchBar.topAnchor.constraint(lessThanOrEqualTo: cityStackView.bottomAnchor, constant: 10),
        locationSearchBar.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
        locationSearchBar.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
        locationSearchBar.heightAnchor.constraint(equalTo: cityStackView.heightAnchor),
        
        descriptionLabel.topAnchor.constraint(lessThanOrEqualTo: locationSearchBar.bottomAnchor, constant: 5),
        descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
        
        degreesLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
        degreesLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -5),
        
        dateLabel.leadingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
        dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: chartView.topAnchor, constant: -15),
        
        weatherIconImageView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        weatherIconImageView.trailingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
        weatherIconImageView.heightAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.334),
        weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor),
        
        chartView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
        chartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        chartView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.559),
        chartView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.694444),
        
        detailsView.topAnchor.constraint(equalTo: chartView.topAnchor),
        detailsView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
        detailsView.leadingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 10),
        detailsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
    ]
    
    private lazy var iPhoneLandscapeConstraints: [NSLayoutConstraint] = [
        cityStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
        cityStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
        
        locationSearchBar.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 5),
        locationSearchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
        locationSearchBar.trailingAnchor.constraint(equalTo: degreesLabel.leadingAnchor, constant: -5),
        
        descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
        descriptionLabel.centerYAnchor.constraint(equalTo: degreesLabel.centerYAnchor),
        
        dateLabel.leadingAnchor.constraint(equalTo: cityStackView.leadingAnchor),
        dateLabel.bottomAnchor.constraint(equalTo: chartView.topAnchor, constant: -5),
        
        degreesLabel.widthAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: 0.4),
        degreesLabel.centerYAnchor.constraint(equalTo: weatherIconImageView.centerYAnchor),
        degreesLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor, constant: -5),
        
        weatherIconImageView.topAnchor.constraint(equalTo: cityStackView.bottomAnchor, constant: 5),
        weatherIconImageView.widthAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: 0.2),
        weatherIconImageView.trailingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: -5),
        weatherIconImageView.bottomAnchor.constraint(equalTo: chartView.topAnchor, constant: -5),
        
        chartView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
        chartView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
        chartView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.55),
        chartView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.65),
        
        detailsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
        detailsView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
        detailsView.leadingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 5),
        detailsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5)
    ]
    
    // MARK: Setting up size classes
    private func layoutForSizes() {
        if isHorizontalRegular && isVerticalRegular {
            addSubview(detailsView)
            if let first = sharedConstraints.first, first.isActive {
                NSLayoutConstraint.deactivate(sharedConstraints)
            }
            if let first = iPhoneLandscapeConstraints.first, first.isActive {
                NSLayoutConstraint.deactivate(iPhoneLandscapeConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        } else if !isVerticalRegular && isLandscape {
            addSubview(detailsView)
            if let first = sharedConstraints.first, first.isActive {
                NSLayoutConstraint.deactivate(sharedConstraints)
            }
            if let first = regularConstraints.first, first.isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(iPhoneLandscapeConstraints)
        } else {
            detailsView.removeFromSuperview()
            forecastCollectionView.removeFromSuperview()
            addSubview(forecastCollectionView)
            if let first = regularConstraints.first, first.isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            if let first = iPhoneLandscapeConstraints.first, first.isActive {
                NSLayoutConstraint.deactivate(iPhoneLandscapeConstraints)
            }
            NSLayoutConstraint.activate(sharedConstraints)
        }
        setupFonts()
    }
    
    private func setupFonts() {
        degreesLabel.font = UIFont(name: "Inter-Regular_Medium", size: 64)
        dateLabel.font = UIFont(name: "Inter-Regular", size: 18)
        
        if isHorizontalRegular && isVerticalRegular {
            cityNameLabel.font = UIFont(name: "Inter-Regular_Medium", size: 24)
            locationSearchBar.searchTextField.font = UIFont(name: "Inter-Regular", size: 22)
            descriptionLabel.font = UIFont(name: "Inter-Regular_Medium", size: 48)
            
        } else {
            cityNameLabel.font = UIFont(name: "Inter-Regular_Medium", size: 20)
            locationSearchBar.searchTextField.font = UIFont(name: "Inter-Regular", size: 18)
            descriptionLabel.font = UIFont(name: "Inter-Regular_Medium", size: 24)
            
        }
    }
    
    // MARK: Setting up weather data
    func setWeather(weather: [Weather], location: String) {
        guard let firstWeather = weather.first else { return }
        
        // TODO: Make normal setting up weather details
        detailsView.setWeather(firstWeather)
        
        // If the date is today, the big weather icon and degrees show information for right now,
        // if not today, they show information for the hottest time of the day.
        if Calendar.current.isDateInToday(firstWeather.date) {
            setMainWeather(firstWeather, location: location)
        } else if let highestTemperatureForecast = weather.max(by: {
            $0.temperature < $1.temperature
        }) {
            setMainWeather(highestTemperatureForecast, location: location)
        }
        
        locationSearchBar.fadeOut(withDuration: 0.15)
        locationSearchBar.resignFirstResponder()
        
        chartView.setChart(weather: weather)
    }
    
    func setMainWeather(_ weather: Weather, location: String) {
        cityNameLabel.text = location
        descriptionLabel.text = weather.description?.capitalized
        degreesLabel.text = "\(Int(weather.temperature.rounded()))°C"
        let day = weather.date.formatted(.dateTime.weekday(.wide))
        let date = weather.date.formatted(.dateTime.day().month().year())
        dateLabel.text = "\(day) | \(date)"
        guard let iconName = weather.iconName else { return }
        detailsView.setWeather(weather)
        Task(priority: .medium) {
            weatherIconImageView.image = await delegate?.getIcon(name: iconName)
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

// MARK: - ChartViewDelegate
extension CurrentWeatherView: WeatherChartViewDelegate {
    
    func getIcon(name: String) async -> UIImage? {
        await delegate?.getIcon(name: name)
    }
    
}
