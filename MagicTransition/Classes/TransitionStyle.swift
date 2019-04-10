//
//  TransitionStyle.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 28.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit

public class TransitionStyle {
    
    public private(set) var transitionDuration: Double = 0.75
    public private(set) var transitionDelay = 0.0
    
    public var persistentToForeground: Bool = false
    
    public var outgoingAnimations: [MagicAnimation] = [AnimationFactory.fadeOut()]
    public var incomingAnimations: [MagicAnimation] = [AnimationFactory.fadeIn()]
    
    public var timingParameter: UICubicTimingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
    
    public var persistentDurationRatio: Double = 1.0
    public var outgoingDurationRatio: Double = 1/3
    public var incomingDurationRatio: Double = 2/3
    
    var persistentAnimationDuration: Double {
        get { return transitionDuration * persistentDurationRatio }
    }
    
    var outgoingAnimationDuration: Double {
        get { return transitionDuration * outgoingDurationRatio }
    }
    
    var incomingAnimationDuration: Double {
        get { return transitionDuration * incomingDurationRatio }
    }
    
    var incomingAnimationDelay: Double {
        get { return transitionDuration - incomingAnimationDuration }
    }
    
    internal init() { }
    
    public init(duration: Double = MagicTransition.transitionStyle.transitionDuration,
         delay: Double = MagicTransition.transitionStyle.transitionDelay,
         timingParameter: UICubicTimingParameters = MagicTransition.transitionStyle.timingParameter,
         persistentRatio: Double = MagicTransition.transitionStyle.persistentDurationRatio,
         outgoingRatio: Double = MagicTransition.transitionStyle.outgoingDurationRatio,
         incomingRatio: Double = MagicTransition.transitionStyle.incomingDurationRatio,
         outgoingAnimations: [MagicAnimation] = MagicTransition.transitionStyle.outgoingAnimations,
         incomingAnimations: [MagicAnimation] = MagicTransition.transitionStyle.incomingAnimations,
         persistentInForeground: Bool = MagicTransition.transitionStyle.persistentToForeground) {
        
        transitionDuration = duration
        transitionDelay = delay
        persistentDurationRatio = persistentRatio
        outgoingDurationRatio = outgoingRatio
        incomingDurationRatio = incomingRatio
        self.outgoingAnimations = outgoingAnimations
        self.incomingAnimations = incomingAnimations
        self.persistentToForeground = persistentInForeground
    }
    
}
