//
//  TinderSwipeGestureController.swift
//  TinderTVTest
//
//  Created by Saniul Ahmed on 07/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation
import UIKit
import pop

class TinderSwipeGestureController {
    
    struct SwipeResult {
        let view: UIView
        let translation: CGPoint
        let velocity: CGPoint
        let direction: SwipeDirection
    }
    
    enum SwipeDirection {
        case None
        case Left
        case Right
    }
    
    enum RotationDirection {
        case None
        case AwayFromCenter
        case TowardsCenter
        
        var multiplier: CGFloat {
            switch self {
            case .None: return 1
            case .AwayFromCenter: return 1
            case .TowardsCenter: return -1
            }
        }
    }
    
    let stackManager: CardStackManager
    
    var originalCenter: CGPoint = CGPoint.zero
    var rotationDirection: RotationDirection = .AwayFromCenter
    let threshold: CGFloat = 100
    
    var resultHandler: (SwipeResult -> Void)?
    
    init(stackManager: CardStackManager) {
        self.stackManager = stackManager
    }
    
    func onPan(gesture: UIPanGestureRecognizer) {
        guard let view = stackManager.firstView else {
            return
        }
        
        switch gesture.state {
        case .Began:
            panBegan(view: view, gesture: gesture)
        case .Ended, .Cancelled:
            panEnded(view: view, gesture: gesture)
        default:
            panChanged(view: view, gesture: gesture)
            
        }
    }
    
    func panBegan(view view: UIView, gesture: UIPanGestureRecognizer) {
        view.pop_removeAllAnimations()
        view.layer.pop_removeAllAnimations()
        
        //HAX: let's cheat and force this to center of superview so we don't have to
        // account for starting the pan gesture while the card is being put back
        let superBounds = view.superview!.bounds
        originalCenter = CGPoint(x: superBounds.width/2, y: superBounds.height/2)
        
        let translation = gesture.translationInView(view)
        updateRotationDirectionBasedOnTranslation(translation)
    }
    
    func panChanged(view view: UIView, gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(view)
        view.center = originalCenter + translation
        
        updateRotationDirectionBasedOnTranslation(translation)
        
        let transform = transformForTranslation(translation,
            rotationDirection:rotationDirection)
        view.layer.transform = transform
    }
    
    func panEnded(view view: UIView, gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(view)
        let velocity = gesture.velocityInView(view)
        
        let selectedDirection = selectedDirectionBasedOn(translation: translation, velocity: velocity)
        switch selectedDirection {
        case .Right, .Left:
            exitSuperview(view: view, translation: translation, velocity: velocity)
        case .None:
            returnToOriginalCenter(view: view, translation: translation, velocity: velocity)
        }
        
        rotationDirection = .None
    }
    
    ///////////////////
    
    func updateRotationDirectionBasedOnTranslation(translation: CGPoint) {
        guard case .None = rotationDirection else {
            return
        }
        
        if translation.y < 0 {
            rotationDirection = .AwayFromCenter
        } else if translation.y > 0 {
            rotationDirection = .TowardsCenter
        } else {
            rotationDirection = .None
        }
    }
    
    let rotationFactor: CGFloat = 3
    func transformForTranslation(translation: CGPoint, rotationDirection: RotationDirection) -> CATransform3D {
        let rotation = (translation.x/100 * rotationFactor).degreesToRadians()
        let transform = CATransform3DMakeRotation(rotationDirection.multiplier * rotation, 0.0, 0.0, 1.0)
        return transform
    }
    
    func selectedDirectionBasedOn(translation translation: CGPoint, velocity: CGPoint) -> SwipeDirection {
        let container = stackManager.containerView
        
        //it's weird to use pop to calculate this, but seems to be working pretty great
        let decayAnimation = POPDecayAnimation(propertyNamed: kPOPViewCenter)
        decayAnimation.fromValue = NSValue(CGPoint: originalCenter + translation)
        decayAnimation.velocity = NSValue(CGPoint: velocity)
        
        let toValue = (decayAnimation.toValue as! NSValue).CGPointValue()
        let resultCenter = toValue - translation
        
        if resultCenter.x > container.bounds.maxX {
            return .Right
        } else if resultCenter.x < container.bounds.minX {
            return .Left
        } else {
            return .None
        }
    }
    
    //////////////////////////
    
    func returnToOriginalCenter(view view: UIView, translation: CGPoint, velocity: CGPoint) {
        let targetCenter = self.originalCenter
        
        let putBackCenterAnimation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        putBackCenterAnimation.toValue = NSValue(CGPoint: targetCenter)
        putBackCenterAnimation.velocity = NSValue(CGPoint: velocity)
        view.pop_addAnimation(putBackCenterAnimation, forKey: "putBackCenterAnimation")
        
        let putBackRotationAnimation = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        putBackRotationAnimation.toValue = 0
        view.layer.pop_addAnimation(putBackRotationAnimation, forKey: "putBackRotationAnimation")
    }
    
    func exitSuperview(view view: UIView, translation: CGPoint, velocity: CGPoint) {
        let direction = selectedDirectionBasedOn(translation: translation, velocity: velocity)
        
        let result = SwipeResult(view: view, translation: translation, velocity: velocity, direction: direction)
        
        let completionAnimation = POPDecayAnimation(propertyNamed: kPOPViewCenter)
        completionAnimation.velocity = NSValue(CGPoint: velocity)
        completionAnimation.completionBlock = { [weak view] animation, completed in
            view?.removeFromSuperview()
        }
        view.pop_removeAllAnimations()
        view.pop_addAnimation(completionAnimation, forKey: "completionAnimation")
        
        resultHandler?(result)
    }
}