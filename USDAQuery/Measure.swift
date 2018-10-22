//
//  Measure.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/8/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

public struct Measure {
    
    public let label: String
    public let eqv: Double
    public let qty: Double
    public let value: String
    
    
    init?(dictionary: JSONDictionary) {
        
        guard let
            label = dictionary[Key.label] as? String,
            let eqv = dictionary[Key.eqv] as? Double,
            let qty = dictionary[Key.qty] as? Double,
            let value = dictionary[Key.value] as? String else { return nil }
        
        self.label = label
        self.eqv = eqv
        self.qty = qty
        self.value = value
    }
}

extension Measure {
    
    static func getMeasure(from results: [Any]) -> [Measure]? {
        
        var measures = [Measure]()
        
        for result in results {
            if let result = result as? JSONDictionary {
                let measure = Measure(dictionary: result)
                
                if let measure = measure {
                    measures.append(measure)
                }
            }
            
        }
        
        return measures
    }
}

extension Measure {
    
    struct Key {
        static let label = "label"
        static let eqv = "eqv"
        static let qty = "qty"
        static let value = "value"
    }
}
