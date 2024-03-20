//
//  CurrentWeatherViewDelegate.swift
//  Weather
//
//  Created by Daniil Rassadin on 18/3/24.
//

import UIKit

protocol CurrentWeatherViewDelegate: AnyObject {
    func updateLocation(_ location: String)
    func getIcon(name: String) async -> UIImage?
}
