//
//  AnimationViewExtension.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 04.04.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import Lottie

public extension AnimationView {
    
    override func getCopy() -> AnimationView {
        if let animation = self.animation {
            return AnimationView(animation: animation)
        }
        return AnimationView()
    }
    
}
