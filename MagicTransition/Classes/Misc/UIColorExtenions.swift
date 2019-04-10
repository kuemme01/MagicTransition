//
//  UIColorExtentions.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 31.01.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0xFF00) >> 8) / 255
        let b = CGFloat((hex & 0xFF)) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
