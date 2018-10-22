//
//  FoodItem.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/7/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

public struct FoodItem {
    
    public let ndbno: String
    public let name: String
    public let ds: String
    
    init?(dictionary: JSONDictionary) {
        guard let
            name = dictionary[Key.name] as? String,
            let ndbno = dictionary[Key.nbdno] as? String,
            let ds = dictionary[Key.ds] as? String
            else { return nil }
        
        self.ndbno = ndbno
        self.name = name
        self.ds = ds
    }
    
}

extension FoodItem {
    
    static func getFoodItems(from results: [JSONDictionary]) -> [FoodItem]? {
        
        var data = [FoodItem]()
        
        for result in results {
            data.append(FoodItem(dictionary: result)!)
        }
        
        return data
    }
}

extension FoodItem {
    
    struct Key {
        static let name = "name"
        static let nbdno = "ndbno"
        static let ds = "ds"
    }
    
}
