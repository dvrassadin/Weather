//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Daniil Rassadin on 20/3/24.
//

import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "ForecastCollectionViewCell"
    override var isSelected: Bool {
        didSet {
            transformSelected()
        }
    }
    
    // MARK: UI components
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Regular", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.opacity = 0.6
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.opacity = 0.6
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        weatherImageView.image = nil
    }
    
    // MARK: Setup UI
    private func setupUI() {
        addSubview(dateLabel)
        addSubview(weatherImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 25),
            dateLabel.widthAnchor.constraint(equalToConstant: 40),
            
            weatherImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            weatherImageView.widthAnchor.constraint(equalTo: dateLabel.widthAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: 39),
            weatherImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setDate(_ date: Date) {
        dateLabel.text = date.formatted(.dateTime.weekday(.abbreviated)).uppercased()
    }
    
    func setImage(_ image: UIImage) {
        weatherImageView.image = image
    }
    
    func transformSelected() {
        UIView.animate(withDuration: 0.2) {
            self.dateLabel.layer.opacity = self.isSelected ? 1 : 0.6
            self.weatherImageView.layer.opacity = self.isSelected ? 1 : 0.6
            self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.1, y: 1.2) : .identity
        }
    }
    
}
