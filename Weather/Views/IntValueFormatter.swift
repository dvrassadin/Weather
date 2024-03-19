//
//  IntValueFormatter.swift
//  Weather
//
//  Created by Daniil Rassadin on 19/3/24.
//

import DGCharts

final class IntValueFormatter: ValueFormatter {
    
    func stringForValue(
        _ value: Double,
        entry: DGCharts.ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: DGCharts.ViewPortHandler?
    ) -> String {
        String(Int(value.rounded()))
    }
    
}
