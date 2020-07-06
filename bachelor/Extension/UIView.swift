//
//  UIView.swift
//  Qapp
//
//  Created by Marc Heimendinger on 07.05.20.
//  Copyright © 2020 Marc Heimendinger. All rights reserved.
//

import UIKit

extension UIView {

    func dropShadow(radius: CGFloat, opacity: Float, color: UIColor = .black, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

}
