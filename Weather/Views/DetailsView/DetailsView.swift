//
//  DetailsView.swift
//  Weather
//
//  Created by Daniil Rassadin on 21/3/24.
//

import UIKit

final class DetailsView: UIView {
    
    // MARK: Properties
    private var isHorizontalRegular: Bool {
        window?.windowScene?.screen.traitCollection.horizontalSizeClass == .regular
    }
    private var isVerticalRegular: Bool {
        window?.windowScene?.screen.traitCollection.verticalSizeClass == .regular
    }
    
    // MARK: UI components
    private let forecastCollectionView: ForecastCollectionView
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .detailsBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let clockImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(
                systemName: "clock.fill"
            )?.withTintColor(.white, renderingMode: .alwaysOriginal)
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let timeTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = String(localized: "AIR CONDITIONS")
        return label
    }()

    private let realFeelItem = DetailItemView(
        title: String(localized: "Real Feel"),
        image: .realFeelIcon
    )
    
    private let windItem = DetailItemView(title: String(localized: "Wind"), image: .windIcon)
    
    private let chanceOfRainItem = DetailItemView(
        title: String(localized: "Chance of rain"),
        image: .chanceOfRainIcon
    )
    
    private let humidityItem = DetailItemView(
        title: String(localized: "Humidity"),
        image: UIImage(
            systemName: "humidity.fill"
        )?.withTintColor(.white, renderingMode: .alwaysOriginal)
    )
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()

    // MARK: Lifecycle
    init(forecastCollectionView: ForecastCollectionView) {
        forecastCollectionView.removeFromSuperview()
        self.forecastCollectionView = forecastCollectionView
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(forecastCollectionView)
        setupConstraints()
        setupFonts()
        layer.cornerRadius = min(frame.height, frame.width) / 30
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .customBackground2
        addSubviews()
    }
    
    private func addSubviews() {
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        addSubview(forecastCollectionView)
        timeTextStackView.addArrangedSubview(clockImageView)
        timeTextStackView.addArrangedSubview(timeTextLabel)
        addSubview(timeTextStackView)
        addSubview(titleLabel)
        detailsStackView.addArrangedSubview(realFeelItem)
        detailsStackView.addArrangedSubview(windItem)
        detailsStackView.addArrangedSubview(chanceOfRainItem)
        detailsStackView.addArrangedSubview(humidityItem)
        addSubview(detailsStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: centerYAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            forecastCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            forecastCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            forecastCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 69),
            
            timeTextStackView.topAnchor.constraint(equalTo: forecastCollectionView.bottomAnchor),
            timeTextStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: timeTextLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            
            realFeelItem.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.0689),
            realFeelItem.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            windItem.heightAnchor.constraint(equalTo: realFeelItem.heightAnchor),
            windItem.widthAnchor.constraint(equalTo: realFeelItem.widthAnchor),
            chanceOfRainItem.heightAnchor.constraint(equalTo: realFeelItem.heightAnchor),
            chanceOfRainItem.widthAnchor.constraint(equalTo: realFeelItem.widthAnchor),
            humidityItem.heightAnchor.constraint(equalTo: realFeelItem.heightAnchor),
            humidityItem.widthAnchor.constraint(equalTo: realFeelItem.widthAnchor),
            
            detailsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            detailsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsStackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func setupFonts() {
        if isVerticalRegular && isHorizontalRegular {
            timeTextLabel.font = UIFont(name: "Inter-Regular_Medium", size: 17)
            titleLabel.font = UIFont(name: "Inter-Regular_Bold", size: 14)
        } else {
            timeTextLabel.font = UIFont(name: "Inter-Regular_Medium", size: 14)
            titleLabel.font = UIFont(name: "Inter-Regular_Bold", size: 12)
        }
    }
    
    // MARK: Setting up weather data
    func setWeather(_ weather: Weather) {
        timeTextLabel.text = weather.date.formatted(.dateTime.hour().minute().timeZone())
        realFeelItem.setData(text: "\(Int(weather.feelsLike.rounded()))°")
        windItem.setData(
            text: String(localized: "\(String(format: "%.2f", weather.windSpeed)) km/hr")
        )
        chanceOfRainItem.setData(text: "\(Int(weather.chanceOfRain * 100))%")
        humidityItem.setData(text: "\(weather.humidity)%")
    }
}
