//
//  ViewController.swift
//  TinderTVTest
//
//  Created by Saniul Ahmed on 05/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit
import pop

class SwipeResultLabel: UILabel {
    enum Mode {
        case Selected
        case Rejected
        
        var text: String {
            switch self {
            case .Selected:
                return "Selected!"
            case .Rejected:
                return "Rejected!"
            }
        }
        
        var color: UIColor {
            switch self {
            case .Selected:
                return UIColor.greenColor()
            case .Rejected:
                return UIColor.redColor()
            }
        }
    }
    
    let mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        
        super.init(frame: CGRect.zero)
        
        font = UIFont.systemFontOfSize(64)
        text = mode.text
        textColor = mode.color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    
    var stackManager: CardStackManager!
    var gestureController: TinderSwipeGestureController!
    
    let panGestureRecognizer = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
        
        panGestureRecognizer.addTarget(self, action: "panGestureRecognizerFired:")
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func reload() {
        stackManager = CardStackManager(containerView: self.view)
        stackManager.items = DATA_ITEMS.map { $0 }.shuffle()
        stackManager.reload()
        
        gestureController = TinderSwipeGestureController(stackManager: stackManager)
        gestureController.resultHandler = { [weak self] result in
            if let item = self?.stackManager.first?.item {
                print("\(item.title) swiped \(result.direction)")
            }
            self?.stackManager.popView()
            self?.animateSwipeResultLabelForResult(result)
        }
    }
    
    func panGestureRecognizerFired(gesture: UIPanGestureRecognizer) {
        gestureController.onPan(gesture)
    }
    
    func animateSwipeResultLabelForResult(result: TinderSwipeGestureController.SwipeResult) {
        let mode: SwipeResultLabel.Mode
        switch result.direction {
        case .Left:
            mode = .Rejected
        case .Right:
            mode = .Selected
        case .None:
            return
        }
        
        let label = SwipeResultLabel(mode: mode)
        label.sizeToFit()
        
        label.center = result.view.center
        view.addSubview(label)
        
        let decayAnimation = POPDecayAnimation(propertyNamed: kPOPViewCenter)
        decayAnimation.velocity = NSValue(CGPoint:CGPoint(x: -result.velocity.x/20, y: -result.velocity.y/20))
        label.pop_addAnimation(decayAnimation, forKey: "decay")
        
        let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnimation.toValue = 0
        alphaAnimation.duration = alphaAnimation.duration * 5
        label.pop_addAnimation(alphaAnimation, forKey: "alpha")
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesBegan(presses, withEvent: event)
        
        if case .Some(.PlayPause) = presses.first?.type {
            reload()
        }
        
    }

}

