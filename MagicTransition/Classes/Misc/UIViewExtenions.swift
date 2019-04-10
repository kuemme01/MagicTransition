//
//  UIViewExtentions.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 03.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

public extension UIView {
    
    @IBInspectable var transitionId: String? {
        get {
            return accessibilityIdentifier
        }
        set {
            accessibilityIdentifier = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    class func getAllSubviews<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(view: subView) as [T]
            if let view = subView as? T {
                if view.transitionId != nil {
                    result.append(view)
                }
            }
            return result
        }
    }
    
    func getAllSubviews<T: UIView>() -> [T] {
        return UIView.getAllSubviews(view: self) as [T]
    }
    
    @objc func getCopy() -> UIView {
        let copy = UIView()
        transferProperties(from: self, to: copy)
        
        return copy
    }
    
    @objc func getProperties(from view: UIView) {
        transferProperties(from: view, to: self)
        if let superview = view.superview {
            self.frame = superview.convert(view.frame, to: nil)
        } else {
            self.frame = view.frame
        }
    }
    
    @objc func transferProperties(from fromView: UIView, to toView: UIView) {
        toView.frame = fromView.frame
        toView.clipsToBounds = fromView.clipsToBounds
        toView.center = fromView.center
        toView.transform = fromView.transform
        toView.alpha = fromView.alpha
        toView.backgroundColor = fromView.backgroundColor
        toView.contentMode = fromView.contentMode
        toView.tintColor = fromView.tintColor
        toView.layer.cornerRadius = fromView.layer.cornerRadius
        toView.layer.shadowColor = fromView.layer.shadowColor
        toView.layer.shadowOffset = fromView.layer.shadowOffset
        toView.layer.shadowRadius = fromView.layer.shadowRadius
        toView.layer.shadowOpacity = fromView.layer.shadowOpacity
        toView.layer.shadowPath = fromView.layer.shadowPath
    }
    
    func snapshotViewWithProperties(afterScreenUpdates: Bool) -> UIView {
        let result = self.snapshotView(afterScreenUpdates: true)!
        result.layer.cornerRadius = self.layer.cornerRadius
        result.layer.shadowColor = self.layer.shadowColor
        result.layer.shadowOffset = self.layer.shadowOffset
        result.layer.shadowRadius = self.layer.shadowRadius
        result.layer.shadowOpacity = self.layer.shadowOpacity
        result.layer.shadowPath = self.layer.shadowPath
        result.layer.cornerRadius = self.layer.cornerRadius
        result.clipsToBounds = false
        
        return result
    }
    
}
