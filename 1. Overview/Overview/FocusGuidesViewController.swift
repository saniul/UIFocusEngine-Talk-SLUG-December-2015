//
//  ViewController.swift
//  UserInitiatedFocusChange
//
//  Created by Saniul Ahmed on 07/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit

class FocusGuidesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        addGuideAtPlaceholder(topLeftGuidePlaceholder, target: leftButton)
        addGuideAtPlaceholder(leftTopGuidePlaceholder, target: topButton)
        addGuideAtPlaceholder(leftBottomGuidePlaceholder, target: bottomButton)
        addGuideAtPlaceholder(bottomLeftGuidePlaceholder, target: leftButton)
        addGuideAtPlaceholder(bottomRightGuidePlaceholder, target: rightButton)
        addGuideAtPlaceholder(rightBottomGuidePlaceholder, target: bottomButton)
        addGuideAtPlaceholder(rightTopGuidePlaceholder, target: topButton)
        addGuideAtPlaceholder(topRightGuidePlaceholder, target: rightButton)
    }
    
    func addGuideAtPlaceholder(placeholder: UIView, target: UIView) {
        let guide = UIFocusGuide()
        guide.preferredFocusedView = target
        view.addLayoutGuide(guide)
        guide.centerXAnchor.constraintEqualToAnchor(placeholder.centerXAnchor).active = true
        guide.centerYAnchor.constraintEqualToAnchor(placeholder.centerYAnchor).active = true
        guide.widthAnchor.constraintEqualToAnchor(placeholder.widthAnchor).active = true
        guide.heightAnchor.constraintEqualToAnchor(placeholder.heightAnchor).active = true
    }
    
    override func shouldUpdateFocusInContext(context: UIFocusUpdateContext) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var topLeftGuidePlaceholder: UIImageView!

    @IBOutlet weak var topRightGuidePlaceholder: UIImageView!
    
    @IBOutlet weak var leftTopGuidePlaceholder: UIImageView!

    @IBOutlet weak var leftBottomGuidePlaceholder: UIImageView!
    
    @IBOutlet weak var bottomLeftGuidePlaceholder: UIImageView!
    @IBOutlet weak var bottomRightGuidePlaceholder: UIImageView!
    
    @IBOutlet weak var rightBottomGuidePlaceholder: UIImageView!
    
    @IBOutlet weak var rightTopGuidePlaceholder: UIImageView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
}

