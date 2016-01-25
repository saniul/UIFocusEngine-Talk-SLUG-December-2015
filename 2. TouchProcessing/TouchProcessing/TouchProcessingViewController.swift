//
//  ViewController.swift
//  CustomTouchesSimple
//
//  Created by Saniul Ahmed on 03/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit

class TouchProcessingView: UIView {
    
    enum Mode {
        case Clamped
        case NotClamped
    }
    
    let dot: UIView = {
        let view = UIView()
        view.bounds.size = CGSize(width: 50, height: 50)
        view.backgroundColor = UIColor.blueColor()
        return view
    }()
    
    var mode: Mode = .Clamped
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        addSubview(dot)
        
        dot.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }

    func updateDotToLocationOfTouch(touch: UITouch) {
        let baseView = self
        
        let location = touch.locationInView(baseView)
        
        switch mode {
        case .Clamped:
            dot.center = clampedLocation(location)
        case .NotClamped:
            dot.center = location
        }
    }
    
    func clampedLocation(location: CGPoint) -> CGPoint {
        var result = location
        result.x = min(bounds.width, max(0,location.x))
        result.y = min(bounds.height, max(0,location.y))
        return result
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        guard let touch = touches.first else {
            return
        }

        updateDotToLocationOfTouch(touch)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        guard let touch = touches.first else {
            return
        }
        
        updateDotToLocationOfTouch(touch)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
    }
}

class TouchProcessingViewController: UIViewController {

    
}

