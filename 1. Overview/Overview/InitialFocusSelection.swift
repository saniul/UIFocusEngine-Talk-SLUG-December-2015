//
//  ViewController.swift
//  InitialFocusSelection
//
//  Created by Saniul Ahmed on 07/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit

class InitialFocusSelectionViewController: UIViewController {
}

class CustomInitialFocusView: UIView {
    @IBOutlet weak var bottomRightButton: UIButton!
    
    override var preferredFocusedView: UIView? {
        return bottomRightButton
    }
}

class CustomInitialFocusSelection: UIViewController {
    
}

