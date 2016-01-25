/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A struct used throughout the sample to represent example data.
*/

import Foundation

struct DataItem: Equatable {
    // MARK: Types
    
    enum Group: String {
        case Scenery
        case Iceland
        case Lola
        case Baby
        
        static let allGroups: [Group] = [.Scenery, .Iceland, .Lola, .Baby]
    }
    
    // MARK: Properties
    
    let group: Group
    
    let number: Int
    
    var title: String {
        return "\(group.rawValue) \(DataItem.numberFormatter.stringFromNumber(number)!)"
    }
    
    var identifier: String {
        return "\(group.rawValue).\(number)"
    }
    
    var displayURL: NSURL {
        let components = NSURLComponents()
        components.scheme = "uikitcatalog"
        components.path = "dataItem"
        components.queryItems = [NSURLQueryItem(name: "identifier", value: identifier)]
        
        return components.URL!
    }
    
    var imageURL: NSURL {
        let mainBundle = NSBundle.mainBundle()
        guard let imageURL = mainBundle.URLForResource(imageName, withExtension: nil) else { fatalError("Error determining local image URL.") }
        
        return imageURL
    }
    
    // MARK: Convenience
    
    /// A static `NSNumberFormatter` used to create a localized title for the `DataItem`.
    private static var numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .SpellOutStyle
        
        return formatter
    }()
}

// MARK: Equatable

func ==(lhs: DataItem, rhs: DataItem)-> Bool {
    // Two `DataItem`s are considered equal if their identifiers match.
    return lhs.identifier == rhs.identifier
}
