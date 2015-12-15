//
//  Spell.swift
//  MultistrokeGestureRecognition
//
//  Created by Saniul Ahmed on 14/12/2015.
//  Copyright © 2015 Saniul Ahmed. All rights reserved.
//

import Foundation

enum Spell {
    case Expelaccio
    case Alohamorrow
    case Curciopendo
    
    var text: String {
        switch self {
        case .Expelaccio: return "Expelaccion"
        case .Alohamorrow: return "Alohamorrow"
        case .Curciopendo: return "Curciopendo"
        }
    }
    
    var color: UIColor {
        switch self {
            
        case .Expelaccio: return .redColor()
        case .Alohamorrow: return .greenColor()
        case .Curciopendo: return .yellowColor()
        }
    }
}

extension Spell {
    init?(glyphName: String) {
        switch glyphName {
        case "X": self = .Expelaccio
        case "square": self = .Curciopendo
        case "triangle": self = .Alohamorrow
        default: return nil
        }
    }
}