//
//  Element.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 22.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit
import Lottie

class Element {
    
    var initialView: UIView
    
    private var _animatedView: UIView?
    var animatedView: UIView {
        get {
            return _animatedView!
        }
        set(newValue) {
            if newValue.isKind(of: UIImageView.self) || newValue.isKind(of: UILabel.self) || newValue.isKind(of: UIVisualEffectView.self) || newValue.isKind(of: AnimationView.self) {
                _animatedView = newValue.getCopy()
            } else {
                newValue.translatesAutoresizingMaskIntoConstraints = true
                _animatedView = newValue.snapshotViewWithProperties(afterScreenUpdates: true)
            }
            _animatedView?.frame = initialFrame!
        }
    }
    
    var initialOrigin: CGPoint? {
        get {
            return initialView.superview?.convert(initialView.frame.origin, to: UIApplication.shared.keyWindow) ?? initialView.frame.origin
        }
    }
    
    var initialFrame: CGRect? {
        get {
            return initialView.superview?.convert(initialView.frame, to: UIApplication.shared.keyWindow) ?? initialView.frame
        }
    }
    
    init(view: UIView) {
        initialView = view
        animatedView = view
    }
    
}
