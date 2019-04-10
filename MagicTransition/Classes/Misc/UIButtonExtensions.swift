//
//  UIButtonExtensions.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 07.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

public extension UIButton {
    
    override func getCopy() -> UIButton {
        let copy = UIButton()
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
        if let fromButton = fromView as? UIButton, let toButton = toView as? UIButton {
            toButton.setTitle(toButton.titleLabel?.text, for: .normal)
            toButton.setImage(fromButton.imageView?.image, for: .normal)
        }
    }
    
}
