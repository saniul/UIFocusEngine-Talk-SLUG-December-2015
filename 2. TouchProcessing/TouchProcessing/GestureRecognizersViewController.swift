//
//  ViewController.swift
//  GestureRecognizers
//
//  Created by Saniul Ahmed on 14/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit

class FocusableView: UIView {
    override func canBecomeFocused() -> Bool {
        return true
    }
    
    var highlighted = false {
        didSet {
            backgroundColor = highlighted ? UIColor.redColor() : UIColor.whiteColor()
        }
    }
}

class FocusableViewWithLabel: FocusableView {
    @IBOutlet
    var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame.size.width = bounds.width
        
        label.center.x = bounds.width/2
        label.center.y = bounds.height/2
    }
}

class GestureRecognizersViewController: UIViewController {
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        
        
        coordinator.addCoordinatedAnimations({ () -> Void in
            context.previouslyFocusedView?.layer.borderWidth = 0
            context.nextFocusedView?.layer.borderWidth = 5
            }, completion: nil)
    }
    
    func toggleViewHighlightForGesture(gesture: UIGestureRecognizer) {
        guard let view = gesture.view as? FocusableView else {
            return
        }
        
        view.highlighted = !view.highlighted
    }
    
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        toggleViewHighlightForGesture(sender)
    }
    
    @IBAction func doubleTapGesture(sender: UITapGestureRecognizer) {
        toggleViewHighlightForGesture(sender)
    }
    
    @IBAction func swipeRightGesture(sender: UISwipeGestureRecognizer) {
        toggleViewHighlightForGesture(sender)
    }
    @IBAction func longPressGesture(sender: UILongPressGestureRecognizer) {
        if case .Began = sender.state {
            toggleViewHighlightForGesture(sender)
        }
        
    }
    
    @IBAction func panGesture(sender: UIPanGestureRecognizer) {
        
        guard let view = sender.view as? FocusableViewWithLabel else {
            return
        }
        
        let translation = sender.translationInView(view)
        
        view.label.text = "∂x:\(Int(translation.x))\n∂y:\(Int(translation.y))"
        view.setNeedsLayout()
    }
}
