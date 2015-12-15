//
//  CardView.swift
//  TinderTVTest
//
//  Created by Saniul Ahmed on 07/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation
import AlamofireImage

class CardView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor(
            red:220/255,
            green:220/255,
            blue:220/255,
            alpha:1
            ).CGColor
        
        backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame.size.width = bounds.width
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: 8, y: bounds.height - titleLabel.bounds.height - 8)
        imageView.frame = bounds
        imageView.frame.size.height = bounds.height - titleLabel.frame.height - 8 - 8
    }
    
    func configureWithItem(item: CardItem) {
        if let
            imageURL = item.imageURL {
                imageView.af_setImageWithURL(imageURL)
        }
        
        titleLabel.text = item.title
    }
}