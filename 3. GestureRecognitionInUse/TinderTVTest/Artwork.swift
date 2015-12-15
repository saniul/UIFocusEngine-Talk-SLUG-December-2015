//
//  Artwork.swift
//  TinderTVTest
//
//  Created by Saniul Ahmed on 07/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation

struct Artwork {
    let title: String
    let imageURL: NSURL?
}

extension Artwork: CardItem {
}

extension Artwork {
    static func artworkFromJSONDict(dict: Dictionary<String, String>) -> Artwork? {
        guard let title = dict["title"] else {
            return nil
        }
        
        let imageURL = dict["image"].flatMap { NSURL.init(string: $0) }
        
        return Artwork(title: title, imageURL: imageURL)
    }
}

let DATA_ITEMS: [Artwork] = {
    let dataURL = NSBundle.mainBundle().URLForResource("data", withExtension: "json")!
    let data = NSData(contentsOfURL: dataURL)!
    let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
    let json = jsonObject as! Array<Dictionary<String, String>>
    let result = json.flatMap { return Artwork.artworkFromJSONDict($0) }
    
    return result
}()