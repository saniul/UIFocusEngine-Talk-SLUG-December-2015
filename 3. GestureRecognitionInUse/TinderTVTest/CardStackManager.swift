//
//  SwipeableStackManager.swift
//  TinderTVTest
//
//  Created by Saniul Ahmed on 07/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation
import UIKit
import pop

protocol CardItem {
    var imageURL: NSURL? { get }
    var title: String { get }
}

class CardStackManager {
    var items = [CardItem]()
    
    var first: (item: CardItem, view: CardView)? = nil
    var firstView: CardView? { return first?.view }
    
    var second: (item: CardItem, view: CardView)? = nil
    var secondView: CardView? { return second?.view }
    
    let containerView: UIView
    
    init(containerView: UIView) {
        self.containerView = containerView
    }
    
    func defaultCardSize() -> CGSize {
        return CGSize(width: 400, height: 600)
    }
    
    func firstViewDefaultCenter() -> CGPoint {
        let center = CGPoint(x: containerView.bounds.width/2, y:containerView.bounds.height/2)
        return center
    }
    
    func firstViewDefaultFrame() -> CGRect {
        let size = defaultCardSize()
        let center = firstViewDefaultCenter()
        
        let origin = CGPoint(x: center.x-size.width/2, y: center.y-size.height/2)
        return CGRect(origin: origin, size: size)
    }
    
    func secondViewDefaultFrame() -> CGRect {
        let size = defaultCardSize()
        let center = firstViewDefaultCenter()
        let offsetCenter = center + CGPoint(x: 0, y: 16)
        let origin = CGPoint(x: offsetCenter.x-size.width/2, y: offsetCenter.y-size.height/2)
        return CGRect(origin: origin, size: size)
    }
    
    func reload() {
        clear()
        
        loadFirstView()
        loadSecondView()
    }
    
    func clear() {
        self.first?.view.removeFromSuperview()
        self.first = nil
        
        self.second?.view.removeFromSuperview()
        self.second = nil
    }
    
    func newCardView(item item: CardItem, frame: CGRect) -> CardView {
        let view = CardView()
        view.configureWithItem(item)
        view.frame = frame
        return view
    }
    
    func loadFirstView() {
        guard !items.isEmpty else {
            return
        }
        
        let firstItem = items.removeFirst()
        let firstView = newCardView(item: firstItem, frame: firstViewDefaultFrame())
        containerView.addSubview(firstView)
        self.first = (firstItem, firstView)
    }
    
    func loadSecondView() {
        guard let firstView = first?.view else {
            return
        }
        guard !items.isEmpty else {
            return
        }
        
        let secondItem = items.removeFirst()
        let secondView = newCardView(item: secondItem, frame: secondViewDefaultFrame())
        containerView.insertSubview(secondView, belowSubview: firstView)
        self.second = (secondItem, secondView)
    }
    
    func popView() {
        first = second
        second = nil
        loadSecondView()
        
        let initialPlacementAnimation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        initialPlacementAnimation.toValue = NSValue(CGPoint: firstViewDefaultCenter())
        first?.view.pop_addAnimation(initialPlacementAnimation, forKey: "initialPlacementAnimation")
    }
}
