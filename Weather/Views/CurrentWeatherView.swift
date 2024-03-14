//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Daniil Rassadin on 14/3/24.
//

import UIKit

final class CurrentWeatherView: UIView {
    
    // MARK: UI components
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        setupUI()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .customBackground
    }
}
