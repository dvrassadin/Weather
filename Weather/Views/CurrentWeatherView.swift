//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

final class CurrentWeatherView: UIView {
    
    // MARK: UI components
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cloudy"
        label.font = UIFont(name: "Inter-Regular_Medium", size: 24)
        label.textColor = .white
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "cloud.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Medium", size: 64)
        label.textColor = .white
        label.text = "26°C"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Regular", size: 18)
        label.textColor = .white
        label.text = "Sunday | 12 Dec 2023"
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
//        UIFont.familyNames.forEach { family in
//            print(family)
//            UIFont.fontNames(forFamilyName: family).forEach { name in
//                print(" ", name)
//            }
//        }
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .customBackground
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        currentWeatherStackView.addArrangedSubview(descriptionLabel)
        currentWeatherStackView.addArrangedSubview(imageView)
        currentWeatherStackView.addArrangedSubview(degreesLabel)
        currentWeatherStackView.addArrangedSubview(dateLabel)
        addSubview(currentWeatherStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currentWeatherStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            currentWeatherStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    func setWeather(weather: Weather) {
        descriptionLabel.text = weather.description?.capitalized
        degreesLabel.text = "\(Int(weather.temperature.rounded()))°C"
        let day = weather.date.formatted(.dateTime.weekday(.wide))
        let date = weather.date.formatted(.dateTime.day().month().year())
        dateLabel.text = "\(day) | \(date)"
    }
}
