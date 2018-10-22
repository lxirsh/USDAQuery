//
//  Methods.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/17/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

extension USDAQuery {
    
    // Get units of measurement for food
    public func getUnitsOfMeasurement(for food: Food) -> [String] {
        
        // Add the default measure of 100 ru (reporting units), usually gram (g) or milliliter (ml)
        let baseUnit = "100" + " " + food.ru
        var units = [baseUnit]
        
        let nutrients = food.nutrients
        
        // Retrieve the first measure. All measures have the same label properties.
        if !nutrients.isEmpty {
            let measures = nutrients[0].measures
            
            for measure in measures {
                units.append(measure.label)
            }
        }
        
        return units
    }
    
    public func getEquivalantGrams(for measurement: String, food: Food) -> Double {
        
        let nutrients = food.nutrients
        
        // Default value of 100 ru, which is returned if the measurement is not found in measures.
        var equivalent: Double = 100
        
        // Retrieve the first measure. All measures have the same label and eqv properties.
        if !nutrients.isEmpty {
            let measures = nutrients[0].measures
            
            for measure in measures {
                if measure.label == measurement {
                    equivalent = measure.eqv
                }
            }
        }
        
        return equivalent
    }
    
    // Return the Measure struct whose label property corresponds to the label parameter
    // The values for 100 ru are not found in the Measure struct, but in the Nutrient struct.
    public func getMeasure(label: String, food: Food) -> Measure? {
        
        let nutrients = food.nutrients
        
        // Retrieve the first measure. All measures have the same label and eqv properties.
        if !nutrients.isEmpty {
            let measures = nutrients[0].measures
            
            for measure in measures {
                if measure.label == label {
                    return measure
                }
            }
        }
        return nil
    }

    
    // Get nutrition data for measurent. Return a value for a specific nutrient.
    public func getNutrientValue(food: Food, nutrientId: String, unit: String) -> String? {
        
        var value: String?
        let nutrients = food.nutrients
        // This unit is not found in the measure struct
        let baseUnit = "100" + " " + food.ru
        
        if !nutrients.isEmpty {
            for nutrient in food.nutrients {
                if nutrient.nutrient_id == nutrientId {
                    // The values for 100 reporting units (baseUnit) is in the nutrient struct
                    if unit == baseUnit {
                        value = nutrient.value
                    } else {
                        // Look for the unit in the array of measures
                        for measure in nutrient.measures {
                            if measure.label == unit {
                                value = measure.value
                            }
                        }
                    }
                }
            }
        }

        return value
    }
    
}

