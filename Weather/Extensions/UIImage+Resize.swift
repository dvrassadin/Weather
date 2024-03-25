//
//  UIImage+Resize.swift
//  Weather
//
//  Created by Daniil Rassadin on 25/3/24.
//

import UIKit
import AVFoundation

extension UIImage {
    
    func resize(_ width: Int, _ height: Int) -> UIImage {
        let maxSize = CGSize(width: width, height: height)

        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: self.size,
            insideRect: CGRect(origin: .zero, size: maxSize)
        )
        let targetSize = availableRect.size

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resized
    }
    
}
