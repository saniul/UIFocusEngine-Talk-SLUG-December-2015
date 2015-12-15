//
//  ViewController.swift
//  MultistrokeGestureRecognition
//
//  Created by Saniul Ahmed on 14/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import UIKit
import pop
import AVFoundation

class ViewController: UIViewController {
    
    var gestureDetectorView: WTMGlyphDetectorView!
    
    let scoreFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
    
    @IBOutlet
    var lblStatus: UILabel!
    
    var lastDetectedGlyph: WTMGlyph?
    
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureDetectorView = WTMGlyphDetectorView(frame: view.bounds)
        gestureDetectorView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        gestureDetectorView.delegate = self
        gestureDetectorView.loadTemplatesWithNamesArray(["square", "X", "triangle"])
        view.addSubview(gestureDetectorView)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        resetLabel()
        setupSound()
    }
    
    func setupSound() {
        _ = try? AVAudioSession.sharedInstance().setCategory("AVAudioSessionCategoryAmbient")
        
        let soundFileURL = NSBundle.mainBundle().URLForResource("magic", withExtension:"wav")!
        
        soundPlayer = try? AVAudioPlayer(contentsOfURL: soundFileURL)
        soundPlayer?.prepareToPlay()
    }
    
    func performSpell(spell: Spell) {
        
        let labelView = SpellLabelView(spell: spell)
        labelView.sizeToFit()
        labelView.center = CGPointMake(view.bounds.width / 2, view.bounds.height / 2)
        view.addSubview(labelView)
        
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        scaleAnimation.toValue = NSValue(CGSize:CGSize(width: 5.0, height: 5.0))
        labelView.pop_addAnimation(scaleAnimation, forKey: "scale")
        
        let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnimation.toValue = 0
        alphaAnimation.duration = alphaAnimation.duration * 4
        labelView.pop_addAnimation(alphaAnimation, forKey: "alpha")
        
        soundPlayer?.play()
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesBegan(presses, withEvent: event)
        
        if case .Some(.PlayPause) = presses.first?.type {
            resetLabel()
            
            if let glyph = lastDetectedGlyph,
                let spell = Spell(glyphName: glyph.name) {
                performSpell(spell)
            }
        }
    }
    
    func resetLabel() {
        gestureDetectorView.reset()
        let glyphNames = self.gestureDetectorView.getGlyphNamesString()
        if glyphNames.characters.count > 0 {
            let statusText = NSString(format:"Loaded with %@ templates.\n\nStart drawing.", self.gestureDetectorView.getGlyphNamesString())
            lblStatus.text = statusText as String
        }

    }
    
}

let GESTURE_SCORE_THRESHOLD: Float = 1.0

extension ViewController: WTMGlyphDetectorViewDelegate {
    
    @objc
    func wtmGlyphDetectorView(theView: WTMGlyphDetectorView, glyphDetected glyph: WTMGlyph, withScore score: Float)
    {
        //Reject detection when quality too low
        //More info: http://britg.com/2011/07/17/complex-gesture-recognition-understanding-the-score/
        if score < GESTURE_SCORE_THRESHOLD {
            return
        }
        
        var statusString = ""
        
        let glyphNames = self.gestureDetectorView.getGlyphNamesString()
        
        if glyphNames.characters.count > 0 {
            statusString += "Loaded with \(glyphNames) templates.\n\n"
        }
        
        let number = NSNumber(float: score)
        let formattedScore = scoreFormatter.stringFromNumber(number) ?? "<ERROR>"
        statusString += "Last gesture detected: \(glyph.name)\nScore: \(formattedScore)" 
        
        self.lblStatus.text = statusString;
        
        lastDetectedGlyph = glyph
    }
}