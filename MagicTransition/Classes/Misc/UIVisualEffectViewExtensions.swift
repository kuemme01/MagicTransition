//
//  UIVisualEffectViewExtensions.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 20.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

public extension UIVisualEffectView {
    
    override func getCopy() -> UIVisualEffectView {
        let copy = UIVisualEffectView()
        transferProperties(from: self, to: copy)
        
        return copy
    }
    
    override func getProperties(from view: UIView) {
        transferProperties(from: view, to: self)
        if let superview = view.superview {
            self.frame = superview.convert(view.frame, to: nil)
        } else {
            self.frame = view.frame
        }
    }
    
    override func transferProperties(from fromView: UIView, to toView: UIView) {
        super.transferProperties(from: fromView, to: toView)
        if let fromVisualEffect = fromView as? UIVisualEffectView, let toVisualEffect = toView as? UIVisualEffectView {
            toVisualEffect.effect = fromVisualEffect.effect
        }
    }
    
}
