//
//  InOutElement.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 19.03.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

class InOutElement: Element {
    
    var animations: [MagicAnimation] = []
    
    var children: [InOutElement]?
    var delay: Double = 0.0
    
    override init(view: UIView) {
        super.init(view: view)
    }
    
    init(view: UIView, animations: [MagicAnimation]) {
        super.init(view: view)
        self.animations = animations
    }
    
    convenience init(parent: (view: UIView, animations: [MagicAnimation]), children: [(view: UIView, animations: [MagicAnimation])], with delay: Double, asIncoming: Bool = false) {
        parent.view.subviews.forEach { $0.isHidden = true }
        self.init(view: parent.view, animations: parent.animations)
        parent.view.subviews.forEach { $0.isHidden = false }
        
        let delayFactor = delay / Double(children.count + 1)
        self.delay = asIncoming ? 0.0 : delayFactor * Double(children.count)
        
        self.children = []
        children.enumerated().forEach { (index, child) in
            let childElement = InOutElement(view: child.view, animations: child.animations)
            childElement.delay = delayFactor * Double(index + (asIncoming ? 1 : 0))
            
            self.children?.append(childElement)
        }
    }
    
}
