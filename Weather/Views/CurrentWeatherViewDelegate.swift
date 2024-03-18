//
//  CurrentWeatherViewDelegate.swift
//  Weather
//
//  Created by Daniil Rassadin on 18/3/24.
//

import Foundation

protocol CurrentWeatherViewDelegate: AnyObject {
    func updateLocation(_ location: String)
}
