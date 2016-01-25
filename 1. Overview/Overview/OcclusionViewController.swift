//
//  ViewController.swift
//  Occlusion
//
//  Created by Saniul Ahmed on 02/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit

class OcclusionViewController: UIViewController {

    @IBOutlet weak var aButton: UIButton!

    @IBOutlet weak var bButton: UIButton!
    
    @IBOutlet weak var cButton: UIButton!
    
    @IBOutlet weak var occlusionImageView: UIImageView!
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        guard case .Some(.PlayPause) = presses.first?.type else {
            return
        }
        occlusionImageView.hidden = !occlusionImageView.hidden
    }
}

