//
//  UIView+Animation.swift
//  Weather
//
//  Created by Daniil Rassadin on 18/3/24.
//

import UIKit

extension UIView {
    func fadeIn(withDuration: TimeInterval) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: withDuration) { self.alpha = 1 }
    }
    
    func fadeOut(withDuration: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: withDuration) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
            if let completion { completion() }
        }

    }
}
