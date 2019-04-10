//
//  UILabelExtentions.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 06.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

public extension UILabel {
    
    override func getCopy() -> UILabel {
        let copy = UILabel()
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
        if let fromLabel = fromView as? UILabel, let toLabel = toView as? UILabel {
            toLabel.textColor = fromLabel.textColor
            toLabel.textAlignment = fromLabel.textAlignment
            toLabel.font = fromLabel.font
            toLabel.text = fromLabel.text
            toLabel.isHighlighted = false
            toLabel.highlightedTextColor = fromLabel.highlightedTextColor
            toLabel.numberOfLines = fromLabel.numberOfLines
        }
    }
    
}
