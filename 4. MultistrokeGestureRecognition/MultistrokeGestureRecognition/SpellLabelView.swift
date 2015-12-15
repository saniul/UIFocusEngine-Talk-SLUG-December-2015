//
//  SpellLabelView.swift
//  MultistrokeGestureRecognition
//
//  Created by Saniul Ahmed on 14/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation

class SpellLabelView: UIView {
    
    let spell: Spell
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let emitter: CAEmitterLayer
    let particle: CAEmitterCell
    
    init(spell: Spell) {
        self.spell = spell
        
        emitter = CAEmitterLayer()
        emitter.seed = arc4random_uniform(UInt32.max)
        particle = CAEmitterCell()
        
        super.init(frame: CGRect.zero)
        
        addSubview(label)
        
        label.font = UIFont.systemFontOfSize(64)
        label.text = spell.text
        
        emitter.emitterMode = kCAEmitterLayerSurface
        emitter.emitterShape = kCAEmitterLayerRectangle
        emitter.renderMode = kCAEmitterLayerAdditive
        
        particle.scale = 0.1
        particle.scaleSpeed = 1.0
        particle.emissionLongitude = 0
        particle.emissionRange = CGFloat(M_PI)
        particle.birthRate = 75
        particle.lifetime = 0.25
        particle.lifetimeRange = 3
        particle.velocity = 0;
        particle.velocityRange = 500;
        particle.spin = CGFloat(0)
        particle.spinRange = CGFloat(M_2_PI)
        particle.color = spell.color.CGColor
        particle.contents = UIImage(named:"bolt.png")!.CGImage
        particle.name = "bolt";
        
        emitter.emitterCells = [particle]
        layer.insertSublayer(emitter, below: label.layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        label.sizeToFit()
        bounds.size = label.bounds.size
        label.frame.origin = CGPoint.zero
        
        emitter.emitterPosition = CGPointMake(bounds.width/2, bounds.height/2)
        emitter.emitterSize = CGSizeMake(bounds.width/2, bounds.height/2)
    }
}