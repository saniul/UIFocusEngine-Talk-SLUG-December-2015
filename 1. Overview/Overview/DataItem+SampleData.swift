/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    An extension of `DataItem` that provides a static array of sample `DataItem`s.
*/

import Foundation

extension DataItem {
    /// A static sample set of `DataItem`s.
    static var sampleItems: [DataItem] = {
        return Group.allGroups.flatMap { group -> [DataItem] in
            let itemCount: Int

            switch group {
                case .Scenery:
                    itemCount = 6
                    
                case .Iceland:
                    itemCount = 8
                    
                case .Lola:
                    itemCount = 4
                    
                case .Baby:
                    itemCount = 8
            }

            return (1...itemCount).map { DataItem(group: group, number: $0) }
        }
    }()
    
    /// A static sample set of `DataItem`s to show on the Top Shelf with inset style.
    static var sampleItemsForInsetTopShelfItems: [DataItem] = {
        // Limit the items we show to the first 4 items in the `Lola` group.
        let lolaItems = DataItem.sampleItems.filter { $0.group == .Lola }
        return Array(lolaItems.prefix(4))
    }()
    
    /// A static sample set of `DataItem`s to show on the Top Shelf with sectioned style.
    static var sampleItemsForSectionedTopShelfItems: [[DataItem]] = {
        /*
            Limit the items we show to the first 2 items in the `Iceland` and
            `Lola` groups.
        */
        return [DataItem.Group.Iceland, DataItem.Group.Lola].map { group in
            let currentGroupItems = DataItem.sampleItems.filter { $0.group == group }
            return Array(currentGroupItems.prefix(2))
        }
    }()
}