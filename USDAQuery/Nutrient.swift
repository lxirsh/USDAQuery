//
//  Nutrients.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/8/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

public struct Nutrient {
    
    // The default value is for 100 ru (reporting units, usually g or ml)
    public let nutrient_id: String
    public let name: String
    public let unit: String
    public let value: String
    public let measures: [Measure]
    
    init?(dictionary: JSONDictionary) {
        
        guard let
            nutrient_id = dictionary[Key.nutrient_id] as? String,
            let name = dictionary[Key.name] as? String,
            let unit = dictionary[Key.unit] as? String,
            let value = dictionary[Key.value] as? String,
            let jsonArray = dictionary[Key.measures] as? [Any],
            let measures = Measure.getMeasure(from: (jsonArray))
            else { return nil }
        
        self.nutrient_id = nutrient_id
        self.name = name
        self.unit = unit
        self.value = value
        self.measures = measures
    }
    
}

extension Nutrient {
    
    static func getNutrients(from results: [Any]) -> [Nutrient]? {
        
        var nutrients = [Nutrient]()
        
        for result in results {
            
            if let result = result as? JSONDictionary {
                let nutrient = Nutrient(dictionary: result)
                
                if let nutrient = nutrient {
                    nutrients.append(nutrient)
                }
            }
            
//            if let result = result as? JSONDictionary {
//                if let nutrient = Nutrient(dictionary: result) {
//                    nutrients.append(nutrient)
//                }
//            }
        }
        
        return nutrients
    }
    
}

extension Nutrient {
    
    struct Key {
        static let nutrient_id = "nutrient_id"
        static let name = "name"
        static let unit = "unit"
        static let value = "value"
        static let measures = "measures"
    }
}
