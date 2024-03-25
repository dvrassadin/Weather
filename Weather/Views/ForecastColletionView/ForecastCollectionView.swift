//
//  ForecastCollectionView.swift
//  Weather
//
//  Created by Daniil Rassadin on 21/3/24.
//

import UIKit

final class ForecastCollectionView: UICollectionView {

    // MARK: Lifecycle
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
