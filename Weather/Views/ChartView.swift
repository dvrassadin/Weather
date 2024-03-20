//
//  ChartView.swift
//  Weather
//
//  Created by Daniil Rassadin on 19/3/24.
//

import UIKit
import DGCharts

final class ChartView: UIView {
    
    // MARK: UI components
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
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Medium", size: 14)
        label.textColor = .white
        label.text = String(localized: "24-hour forecast")
        return label
    }()
    
    private let chart: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.noDataTextColor = .white
        if let font = UIFont(name: "Inter-Regular_Medium", size: 12) {
            chart.noDataFont = font
        }
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = false
        chart.legend.enabled = false
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = false
        chart.minOffset = 25
        chart.animate(xAxisDuration: 1)
        return chart
    }()
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        setupUI()
    }

    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .customBackground2
        layer.cornerRadius = min(frame.height, frame.width) / 25
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(clockImageView)
        addSubview(textLabel)
        addSubview(chart)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            clockImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            clockImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            clockImageView.heightAnchor.constraint(equalToConstant: 18),
            clockImageView.widthAnchor.constraint(equalTo: clockImageView.heightAnchor),
            
            textLabel.topAnchor.constraint(equalTo: clockImageView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 5),
            textLabel.heightAnchor.constraint(equalTo: clockImageView.heightAnchor),
            
            chart.topAnchor.constraint(equalTo: clockImageView.bottomAnchor, constant: 5),
            chart.leadingAnchor.constraint(equalTo: leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: trailingAnchor),
            chart.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setChart(weather: [Weather]) {
        let values = weather.map {
            ChartDataEntry(x: Double($0.date.timeIntervalSince1970), y: $0.temperature)
        }
        let chartDataSet = LineChartDataSet(entries: values)
        chartDataSet.mode = .horizontalBezier
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 2
        chartDataSet.setColor(.chartLine)
        if let font = UIFont(name: "Inter-Regular_Medium", size: 14) {
            chartDataSet.valueFont = font
        }
        chartDataSet.valueTextColor = .white
        chartDataSet.valueFormatter = IntValueFormatter()
        let chartData = LineChartData(dataSet: chartDataSet)
        chart.data = chartData
    }
    
}
