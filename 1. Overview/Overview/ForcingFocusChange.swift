//
//  ViewController.swift
//  ForcingFocusChange
//
//  Created by Saniul Ahmed on 07/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit

class FocusRetargetingView: UIView {
    
    var viewToRetargetFocusView: UIView? = nil
    
    override var preferredFocusedView: UIView? {
        if let view = viewToRetargetFocusView {
            return view
        } else {
            return super.preferredFocusedView
        }
    }
}

class ForcingFocusChangeViewController: UIViewController {

    @IBOutlet weak var rootContainer: FocusRetargetingView!
    
    @IBOutlet weak var aContainer: FocusRetargetingView!
    
    @IBOutlet weak var bContainer: FocusRetargetingView!
    
    @IBOutlet weak var axButton: UIView!
    
    @IBOutlet weak var ayButton: UIView!
    
    @IBOutlet weak var bxButton: UIView!
    
    @IBOutlet weak var byButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (view as! FocusRetargetingView).viewToRetargetFocusView = rootContainer
        
        updateTier1Retargeting()
        updateTier2Retargeting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum Tier1Choice {
        case A
        case B
        
        mutating func toggle() {
            switch self {
            case .A:
                self = .B
            case .B:
                self = .A
            }
        }
    }
    
    enum Tier2Choice {
        case X
        case Y
        
        mutating func toggle() {
            switch self {
            case .X:
                self = .Y
            case .Y:
                self = .X
            }
        }
    }
    
    var t1Choice: Tier1Choice = .A {
        didSet {
            updateTier1Retargeting()
        }
    }
    var t2Choice: Tier2Choice = .X {
        didSet {
            updateTier2Retargeting()
        }
    }

    
    var choice: (t1: Tier1Choice, t2: Tier2Choice) {
        return (t1: t1Choice, t2: t2Choice)
    }
    
    func updateTier1Retargeting() {
        
        switch t1Choice {
        case .A:
            rootContainer.viewToRetargetFocusView = aContainer
            rootContainerLabel.text = "preferred: A"
        case .B:
            rootContainer.viewToRetargetFocusView = bContainer
            rootContainerLabel.text = "preferred: B"
        }
    }
    
    func updateTier2Retargeting() {
        switch t2Choice {
        case .X:
            aContainer.viewToRetargetFocusView = axButton
            aContainerLabel.text = "preferred: AX"
            bContainer.viewToRetargetFocusView = bxButton
            bContainerLabel.text = "preferred: BX"
        case .Y:
            aContainer.viewToRetargetFocusView = ayButton
            aContainerLabel.text = "preferred: AY"
            bContainer.viewToRetargetFocusView = byButton
            bContainerLabel.text = "preferred: BY"
        }
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesEnded(presses, withEvent: event)
        
        guard let press = presses.first else {
            return
        }
        
        print(press.type.rawValue)
        
        switch press.type {
        case .PlayPause:
            t1Choice.toggle()
        case .LeftArrow, .RightArrow:
            t2Choice.toggle()
        default:
            return
        }
        view.setNeedsFocusUpdate()
        view.updateFocusIfNeeded()
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
    }

    @IBOutlet weak var rootContainerLabel: UILabel!

    @IBOutlet weak var aContainerLabel: UILabel!
    
    @IBOutlet weak var bContainerLabel: UILabel!
    
    override func shouldUpdateFocusInContext(context: UIFocusUpdateContext) -> Bool {
        return false
    }
}

