//
//  MagicAnimation.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 14.03.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

@objc public protocol MagicAnimation {
    @objc optional func prepareBeforeAnimation(view: UIView)
    func animation(view: UIView) -> (()->Void)
    @objc optional func customAnimation(view: UIView, duration: Double)
    @objc optional func updateCustomAnimation(view: UIView, percentComplete: CGFloat)
    @objc optional func animationCompletion(view: UIView)
}
