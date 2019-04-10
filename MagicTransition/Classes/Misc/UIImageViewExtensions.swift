//
//  UIImageViewExtenstions.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 05.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//
import UIKit

public extension UIImageView {
    
    override func getCopy() -> UIImageView {
        let copy = UIImageView()
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
        if let fromImageView = fromView as? UIImageView, let toImageView = toView as? UIImageView {
            toImageView.image = fromImageView.image
            toImageView.layer.cornerRadius = fromImageView.layer.cornerRadius
            toImageView.clipsToBounds = fromImageView.clipsToBounds
            toImageView.isHighlighted = fromImageView.isHighlighted
        }
    }
    
}
