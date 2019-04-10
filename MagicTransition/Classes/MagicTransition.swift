//
//  MagicTransition.swift
//  ThesisApp
//
//  Created by Erik Kümmerling on 03.02.19.
//  Copyright © 2019 Erik Kümmerling. All rights reserved.
//

import UIKit
import Lottie

public class MagicTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    // MARK: - TransitionStyle variables
    public static var transitionStyle: TransitionStyle = TransitionStyle()
    public var customTransitionStyle: TransitionStyle?
    
    private var style: TransitionStyle {
        get {
            return customTransitionStyle ?? MagicTransition.transitionStyle
        }
    }
    
    
    // MARK: - MagicTransition variables
    private var isPresenting = true
    
    private var persistentElements: [PersistentElement] = []
    private var persistentLottieElements: [(view: AnimationView, animation: MagicAnimation)] = []
    private var outgoingElements: [InOutElement] = []
    private var incomingElements: [InOutElement] = []
    
    
    // MARK: - Methods to add views to MagicTransition
    public func addOutgoingElement(view: UIView) {
        outgoingElements.append(InOutElement(view: view, animations: style.outgoingAnimations))
    }
    public func addOutgoingElement(view: UIView, with animations: [MagicAnimation]) {
        outgoingElements.append(InOutElement(view: view, animations: animations))
    }
    
    public func addIncomingElement(view: UIView) {
        incomingElements.append(InOutElement(view: view, animations: style.incomingAnimations))
    }
    public func addIncomingElement(view: UIView, with animations: [MagicAnimation]) {
        incomingElements.append(InOutElement(view: view, animations: animations))
    }
    
    public func addOutgoingGroup(parent: UIView, children: [UIView], with delayFactor: Double = 1.0) {
        outgoingElements.append(InOutElement(parent: (view: parent, animations: style.outgoingAnimations),
                                             children: children.map { child in (view: child, animations: style.outgoingAnimations) },
                                             with: delayFactor))
    }
    public func addOutgoingGroup(parent: (view: UIView, animations: [MagicAnimation]), children: [(view: UIView, animations: [MagicAnimation])], with delayFactor: Double = 1.0) {
        outgoingElements.append(InOutElement(parent: parent, children: children, with: delayFactor))
    }
    
    public func addIncomingGroup(parent: (view: UIView, animations: [MagicAnimation]), children: [(view: UIView, animations: [MagicAnimation])], with delayFactor: Double = 1.0) {
        incomingElements.append(InOutElement(parent: parent, children: children, with: delayFactor, asIncoming: true))
    }
    public func addIncomingGroup(parent: UIView, children: [UIView], with delayFactor: Double = 1.0) {
        incomingElements.append(InOutElement(parent: (view: parent, animations: style.incomingAnimations),
                                             children: children.map { child in (view: child, animations: style.incomingAnimations) },
                                             with: delayFactor))
    }
    
    public func addCustomPersistentElement(view: AnimationView, animation: MagicAnimation) {
        persistentLottieElements.append((view: view, animation: animation))
    }
    
    
    // MARK: - UIViewControllerAnimatedTransitioning API
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return style.transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimator(using: transitionContext).startAnimation()
        persistentLottieElements.forEach { element in
            element.animation.customAnimation?(view: element.view, duration: style.persistentAnimationDuration)
        }
    }
    
    
    // MARK: - UIPercentDrivenInteractiveTransition API
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionAnimator(using: transitionContext)
    }
    
    public func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: style.timingParameter)
        
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        toView.isHidden = isPresenting
        
        containerView.addSubview(toView)
        
        persistentElements = getPersistentElements(fromView: fromView, toView: toView)
        
        // Add elements to containerView
        if isPresenting {
            add(outgoingElements, to: containerView)
            add(persistentElements, to: containerView)
            add(incomingElements, to: containerView)
        } else {
            add(incomingElements, to: containerView)
            add(persistentElements, to: containerView)
            add(outgoingElements, to: containerView)
        }
        if style.persistentToForeground {
            persistentElements.forEach { element in
                containerView.bringSubviewToFront(element.animatedView)
            }
        }
        
        // configure animations
        addAnimations(from: outgoingElements, to: animator)
        addAnimations(from: incomingElements, to: animator, isIncoming: true)
        persistentElements.forEach { element in
            animator.addAnimations {
                if element.animatedView.isKind(of: UILabel.self) {
                    element.animatedView.transform = element.scaleTransform
                    element.animatedView.center = element.targetCenter
                } else {
                    element.animatedView.getProperties(from: element.targetView)
                }
            }
        }
        
        // remove elements from containerView
        animator.addCompletion { position in
            
            switch position {
            case .start:
                transitionContext.completeTransition(true)
            case .current:
                break
            case .end:
                toView.isHidden = false
                
                self.startAnimationCompletions(for: self.outgoingElements)
                self.startAnimationCompletions(for: self.incomingElements)
                
                self.persistentElements.forEach { element in
                    element.animatedView.removeFromSuperview()
                    element.initialView.isHidden = false
                    element.targetView.isHidden = false
                    if !self.isPresenting {
                        if self.isChildOfCollection(view: element.targetView) {
                            element.targetView.transitionId = nil
                        }
                    }
                }
                
                self.remove(self.outgoingElements)
                self.remove(self.incomingElements)
                
                self.persistentElements.removeAll()
                self.outgoingElements.removeAll()
                self.incomingElements.removeAll()
                
                self.isPresenting = !self.isPresenting
                transitionContext.completeTransition(true)
            }
            
        }
        
        return animator
    }
    
    override public func update(_ percentComplete: CGFloat) {
        updateCustomAnimation(for: outgoingElements, toPercentComplete: percentComplete)
        updateCustomAnimation(for: incomingElements, toPercentComplete: percentComplete)
        super.update(percentComplete)
    }
    
    
    // MARK: - ContainerView content helper
    private func add(_ elements: [InOutElement], to containerView: UIView) {
        for element in elements.reversed() {
            containerView.addSubview(element.animatedView)
            element.initialView.isHidden = true
            if let children = element.children {
                for childElement in children {
                    containerView.addSubview(childElement.animatedView)
                    childElement.initialView.isHidden = true
                }
            }
        }
    }
    
    private func add(_ elements: [PersistentElement], to containerView: UIView) {
        elements.forEach { element in
            containerView.addSubview(element.animatedView)
            element.initialView.isHidden = true
            element.targetView.isHidden = true
        }
    }
    
    private func remove(_ elements: [InOutElement]) {
        for element in elements {
            if let children = element.children {
                for childElement in children {
                    childElement.animatedView.removeFromSuperview()
                    childElement.initialView.isHidden = false
                }
            }
            element.animatedView.removeFromSuperview()
            element.initialView.isHidden = false
        }
    }
    
    
    // MARK: - Animator content helper
    private func addAnimations(from elements: [InOutElement], to animator: UIViewPropertyAnimator, isIncoming: Bool = false) {
        let categorieDurationRatio = isIncoming ? style.incomingDurationRatio : style.outgoingDurationRatio
        let relativeStartTime = isIncoming ? style.outgoingDurationRatio : 0.0
        
        elements.forEach { element in
            element.animations.forEach { anim in
                var relativeDurationDivider = 1.0
                
                
                // Animations for possible children
                if let children = element.children {
                    relativeDurationDivider = Double(children.count)
                    children.forEach { childElement in
                        childElement.animations.forEach { anim in
                            anim.prepareBeforeAnimation?(view: childElement.animatedView)
                            animator.addAnimations {
                                UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, animations: {
                                    UIView.addKeyframe(withRelativeStartTime: relativeStartTime + categorieDurationRatio * childElement.delay,
                                                       relativeDuration: categorieDurationRatio / relativeDurationDivider,
                                                       animations: anim.animation(view: childElement.animatedView))
                                })
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + (isIncoming ? style.outgoingAnimationDuration : 0.0) + style.outgoingAnimationDuration + categorieDurationRatio * childElement.delay) {
                                anim.customAnimation?(view: element.animatedView, duration: categorieDurationRatio / relativeDurationDivider)
                            }
                        }
                    }
                }
                
                
                // Animations for parent or single Element
                anim.prepareBeforeAnimation?(view: element.animatedView)
                animator.addAnimations {
                    UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, animations: {
                        UIView.addKeyframe(withRelativeStartTime: relativeStartTime + categorieDurationRatio * element.delay,
                                           relativeDuration: categorieDurationRatio / relativeDurationDivider,
                                           animations: anim.animation(view: element.animatedView))
                    })
                }
                if isIncoming {
                    DispatchQueue.main.asyncAfter(deadline: .now() + style.outgoingAnimationDuration) {
                        anim.customAnimation?(view: element.animatedView, duration: self.style.incomingAnimationDuration)
                    }
                } else {
                    anim.customAnimation?(view: element.animatedView, duration: style.outgoingAnimationDuration)
                }
                
            }
        }
    }
    
    private func updateCustomAnimation(for elements: [InOutElement], toPercentComplete percentComplete: CGFloat) {
        elements.forEach { element in
            element.animations.forEach({ anim in
                anim.updateCustomAnimation?(view: element.animatedView, percentComplete: percentComplete)
            })
        }
    }
    
    private func startAnimationCompletions(for elements: [InOutElement]) {
        elements.forEach { element in
            element.animations.forEach { anim in
                if let children = element.children {
                    children.forEach { childElement in
                        childElement.animations.forEach { anim in
                            anim.animationCompletion?(view: childElement.animatedView)
                        }
                    }
                }
                anim.animationCompletion?(view: element.animatedView)
            }
        }
    }
    
    
    // MARK: - MagicTransition helper
    private func getPersistentElements(fromView: UIView, toView: UIView) -> [PersistentElement] {
        var fromViews = fromView.getAllSubviews()
        var toViews = toView.getAllSubviews()
        
        if fromView.transitionId != nil {
            let view = fromView.snapshotView(afterScreenUpdates: true)!
            view.transitionId = fromView.transitionId
            fromViews.insert(view, at: 0)
        }
        if toView.transitionId != nil { toViews.insert(toView, at: 0) }
        
        var persistentElements: [PersistentElement] = []
        
        fromViews.forEach { fromView in
            toViews.forEach { toView in
                if fromView.transitionId == toView.transitionId {
                    persistentElements.append(PersistentElement(fromView: fromView, toView: toView))
                }
            }
        }
        
        return persistentElements
    }
    
    private func isChildOfCollection(view: UIView) -> Bool {
        if let superview = view.superview {
            if superview.isKind(of: UICollectionView.self) || superview.isKind(of: UITableView.self) {
                return true
            }
            return isChildOfCollection(view: superview)
        }
        return false
    }
    
}
