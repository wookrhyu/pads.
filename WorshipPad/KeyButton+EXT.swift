//
//  KeyButton+EXT.swift
//  WorshipPad
//
//  Created by Wook Rhyu on 8/24/21.
//

import UIKit

extension UIButton {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
