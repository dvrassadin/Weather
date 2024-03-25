//
//  ChartView.swift
//  Weather
//
//  Created by Daniil Rassadin on 19/3/24.
//

import UIKit
import DGCharts

final class ChartView: UIView {
    
    // MARK: Properties
    weak var delegate: WeatherChartViewDelegate?
    
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
    
    let chart: LineChartView = {
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
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        setupConstraints()
        layer.cornerRadius = min(frame.height, frame.width) / 30
    }

    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .customBackground2
        addSubviews()
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
        var values = [ChartDataEntry]()
        weather.enumerated().forEach { index, item in
            values.append(ChartDataEntry(x: Double(index), y: item.temperature))
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
        chartDataSet.valueFormatter = DegreesValueFormatter()
        chartDataSet.iconsOffset = CGPoint(x: 0, y: 20)
        let chartData = LineChartData(dataSet: chartDataSet)
        chart.data = chartData
        
        weather.enumerated().forEach { index, item in
            guard let iconName = item.iconName else { return }
            Task(priority: .medium) {
                guard let icon = await delegate?.getIcon(name: iconName)?.resize(40, 40)
                else { return }
                chart.data?.dataSet(at: 0)?.entriesForXValue(Double(index)).first?.icon = icon
                chart.notifyDataSetChanged()
            }
        }
    }
    
}
