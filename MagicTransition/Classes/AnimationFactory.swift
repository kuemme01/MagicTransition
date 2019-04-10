//
//  AnimationFactory.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 16.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit
import Lottie

public enum Direction {
    case top, right, bottom, left
}

public class AnimationFactory {
    
    public static func fadeOut() -> MagicAnimation {
        return FadeOutAnimation()
    }

    public static func fadeIn() -> MagicAnimation {
        return FadeInAnimation()
    }

    public static func zoomOut() -> MagicAnimation {
        return ZoomOutAnimation()
    }

    public static func zoomIn() -> MagicAnimation {
        return ZoomInAnimation()
    }

    public static func slideOut(to direction: Direction) -> MagicAnimation {
        switch direction {
        case .top: return SlideOutToTop()
        case .right: return SlideOutToRight()
        case .bottom: return SlideOutToBottom()
        case .left: return SlideOutToLeft()
        }
    }

    public static func slideIn(from direction: Direction) -> MagicAnimation {
        switch direction {
        case .top: return SlideInFromTop()
        case .right: return SlideInFromRight()
        case .bottom: return SlideInFromBottom()
        case .left: return SlideInFromLeft()
        }
    }
    
    public static func popUp() -> MagicAnimation {
        return PopUp()
    }
    
    public static func popUpReversed() -> MagicAnimation {
        return PopUpReversed()
    }

    public static func valueUp() -> MagicAnimation {
        return ValueUpAnimation()
    }

    public static func valueDown() -> MagicAnimation {
        return ValueDownAnimation()
    }

    public static func lottie() -> MagicAnimation {
        return LottieAnimation()
    }
}

private class LottieAnimation: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {}
    }
    
    func customAnimation(view: UIView, duration: Double) {
        if let lottie = view as? AnimationView {
            let speed = lottie.animation!.duration / duration
            lottie.animationSpeed = CGFloat(speed)
            lottie.play()
        }
    }
}

private class ValueUpAnimation: MagicAnimation {
    var label: UILabel?
    var interactive: Bool = false
    
    var start: Double = 0
    var end: Double = 0
    var animationDuration: Double?
    let animationStartDate = Date()
    
    func prepareBeforeAnimation(view: UIView) {
        if let label = view as? UILabel {
            self.end = Double(label.text!) ?? 0
            label.text = String(start)
        }
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {}
    }
    
    func customAnimation(view: UIView, duration: Double) {
        animationDuration = Double(duration)
        if let label = view as? UILabel {
            self.label = label
            let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
            displayLink.add(to: .main, forMode: .default)
        }
    }
    
    func updateCustomAnimation(view: UIView, percentComplete: CGFloat) {
        interactive = true
        if let label = view as? UILabel {
            let value = 100 * Double(percentComplete)
            print("value: \(value), end: \(end), percent: \(percentComplete)")
            print(value)
            label.text = "\(Int(value))"
        }
    }
    
    @objc func handleUpdate() {
        if !interactive {
            let now = Date()
            let elipsedTime = now.timeIntervalSince(animationStartDate)
            
            if elipsedTime > animationDuration! {
                self.label!.text = "\(Int(end))"
            } else {
                let percentage = elipsedTime / animationDuration!
                let value = start + percentage * (end - start)
                self.label!.text = "\(Int(value))"
            }
        }
    }
    
    func animationCompletion(view: UIView) {}
}

private class ValueDownAnimation: MagicAnimation {
    var label: UILabel?
    
    var start: Double = 0
    var end: Double = 0
    var animationDuration: Double?
    let animationStartDate = Date()
    
    func animation(view: UIView) -> (() -> Void) {
        return {}
    }
    
    func customAnimation(view: UIView, duration: Double) {
        animationDuration = Double(duration)
        if let label = view as? UILabel, let start = Double(label.text!){
            self.label = label
            self.start = start
            let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
            displayLink.add(to: .main, forMode: .default)
        }
    }
    
    @objc func handleUpdate() {
        let now = Date()
        let elipsedTime = now.timeIntervalSince(animationStartDate)
        
        if elipsedTime > animationDuration! {
            self.label!.text = "\(Int(end))"
        } else {
            let percentage = elipsedTime / animationDuration!
            let value = start - (start * percentage)
            self.label!.text = "\(Int(value))"
        }
    }
}

private class FadeOutAnimation: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.alpha = 0.0
        }
    }
}

private class FadeInAnimation: MagicAnimation {
    func prepareBeforeAnimation(view: UIView) {
        view.alpha = 0.0
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.alpha = 1.0
        }
    }
}

private class ZoomOutAnimation: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }
    }
}

private class ZoomInAnimation: MagicAnimation {
    func prepareBeforeAnimation(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.transform = .identity
        }
    }
}

private class SlideOutToTop: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.y = -view.frame.height
        }
    }
}

private class SlideOutToRight: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.x = UIScreen.main.bounds.size.width
        }
    }
}

private class SlideOutToBottom: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.y = UIScreen.main.bounds.size.height
        }
    }
}

private class SlideOutToLeft: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.x = -view.frame.width
        }
    }
}

private class SlideInFromTop: MagicAnimation {
    var initialY: CGFloat?
    
    func prepareBeforeAnimation(view: UIView) {
        initialY = view.frame.origin.y
        view.frame.origin.y = -((view.frame.origin.y >= 0 ? view.frame.origin.y : 0.0) + view.frame.height)
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.y = self.initialY!
        }
    }
}

private class SlideInFromRight: MagicAnimation {
    var initialX: CGFloat?
    
    func prepareBeforeAnimation(view: UIView) {
        initialX = view.frame.origin.x
        view.frame.origin.x = UIScreen.main.bounds.size.width
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.x = self.initialX!
        }
    }
}

private class SlideInFromBottom: MagicAnimation {
    var initialY: CGFloat?
    
    func prepareBeforeAnimation(view: UIView) {
        initialY = view.frame.origin.y
        view.frame.origin.y = UIScreen.main.bounds.size.height
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.y = self.initialY!
        }
    }
}

private class SlideInFromLeft: MagicAnimation {
    var initialX: CGFloat?
    
    func prepareBeforeAnimation(view: UIView) {
        initialX = view.frame.origin.x
        view.frame.origin.x = -((view.frame.origin.x >= 0 ? view.frame.origin.x : 0.0) + view.frame.width)
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.x = self.initialX!
        }
    }
}

private class PopUp: MagicAnimation {
    var initialY: CGFloat?
    var initialAlpha: CGFloat?
    
    func prepareBeforeAnimation(view: UIView) {
        initialAlpha = view.alpha
        view.frame.origin.y += 20
        view.alpha = 0.0
    }
    
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.y -= 20
            view.alpha = self.initialAlpha!
        }
    }
}

private class PopUpReversed: MagicAnimation {
    func animation(view: UIView) -> (() -> Void) {
        return {
            view.frame.origin.y += 20
            view.alpha = 0.0
        }
    }
}
