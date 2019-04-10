//
//  MagicElement.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 05.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

class PersistentElement: Element {
    
    var targetView: UIView
    
    var targetOrigin: CGPoint? {
        get {
            return targetView.superview?.convert(targetView.frame.origin, to: UIApplication.shared.keyWindow)
        }
    }
    
    var targetFrame: CGRect? {
        get {
            return targetView.superview?.convert(targetView.frame, to: UIApplication.shared.keyWindow)
        }
    }
    
    var scaleTransform: CGAffineTransform {
        get {
            let xScale = targetFrame!.width / initialFrame!.width
            let yScale = targetFrame!.height / initialFrame!.height
            return CGAffineTransform(scaleX: xScale, y: yScale)
        }
    }
    
    var targetCenter: CGPoint {
        return (targetView.superview?.convert(targetView.center, to: UIApplication.shared.keyWindow))!
    }
    
    init(fromView: UIView, toView: UIView) {
        targetView = toView
        
        fromView.subviews.forEach { view in
            view.isHidden = true
        }
        super.init(view: fromView)
        fromView.subviews.forEach { view in
            view.isHidden = false
        }
    }
    
}
