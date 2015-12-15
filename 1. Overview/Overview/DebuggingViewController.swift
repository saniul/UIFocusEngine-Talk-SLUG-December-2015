//
//  DebuggingViewController.swift
//  Overview
//
//  Created by Saniul Ahmed on 14/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation
import UIKit

class DebuggingViewController: UIViewController {
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        // ADD A BREAKPOINT HERE TO INSPECT THE `context`
    }
}