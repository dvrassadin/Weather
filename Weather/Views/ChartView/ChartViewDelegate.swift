//
//  ChartViewDelegate.swift
//  Weather
//
//  Created by Daniil Rassadin on 25/3/24.
//

import UIKit

protocol WeatherChartViewDelegate: AnyObject {
    
    func getIcon(name: String) async -> UIImage?
    
}
