//
//  Food.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/15/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

public struct Food {
    
    public let ndbno: String
    public let name: String
    public let ds: String
    public let ru: String
    public let nutrients: [Nutrient]
    
    init?(dictionary: JSONDictionary) {
        guard let
            name = dictionary[Key.name] as? String,
            let ndbno = dictionary[Key.nbdno] as? String,
            let ds = dictionary[Key.ds] as? String,
            let ru = dictionary[Key.ru] as? String,
            let jsonArray = dictionary[Key.nutrients] as? [Any],
            let nutrients = Nutrient.getNutrients(from: jsonArray)
            else { return nil }
        
        self.ndbno = ndbno
        self.name = name
        self.ds = ds
        self.ru = ru
        self.nutrients = nutrients
    }
}

extension Food {
    
    static func getFood(from results: [JSONDictionary]) -> [Food]? {
        
        var data = [Food]()
        
        for result in results {
            let food = Food(dictionary: result)
            
            if let food = food {
                data.append(food)
            }
//            data.append(Food(dictionary: result)!)
        }
        
        return data
    }
    
}

extension Food {
    
    struct Key {
        static let name = "name"
        static let nbdno = "ndbno"
        static let ds = "ds"
        static let ru = "ru"
        static let nutrients = "nutrients"
    }
}
