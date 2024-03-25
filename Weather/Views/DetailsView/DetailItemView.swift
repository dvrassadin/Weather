//
//  DetailItemView.swift
//  Weather
//
//  Created by Daniil Rassadin on 22/3/24.
//

import UIKit

final class DetailItemView: UIView {
    
    //MARK: Properties
    private var isHorizontalRegular: Bool {
        window?.windowScene?.screen.traitCollection.horizontalSizeClass == .regular
    }
    private var isVerticalRegular: Bool {
        window?.windowScene?.screen.traitCollection.verticalSizeClass == .regular
    }

    // MARK: UI components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Medium", size: 16)
        label.textColor = .white
        return label
    }()
    
    // MARK: Lifecycle
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        setupFonts()
    }
    
    // MARK: Setup UI
    private func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(dataLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6757),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            dataLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dataLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
    
    private func setupFonts() {
        if isVerticalRegular && isHorizontalRegular {
            titleLabel.font = UIFont(name: "Inter-Regular_Medium", size: 12)
            dataLabel.font = UIFont(name: "Inter-Regular_Medium", size: 16)
        } else {
            titleLabel.font = UIFont(name: "Inter-Regular_Medium", size: 10)
            dataLabel.font = UIFont(name: "Inter-Regular_Medium", size: 14)
        }
    }
    
    // MARK: Setting up weather data
    func setData(text: String) {
        dataLabel.text = text
    }
}
