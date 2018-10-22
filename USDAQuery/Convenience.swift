//
//  Convenience.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/7/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

extension USDAQuery {
    
    public func fetchResults(for query: String, completionHandler: @escaping (_ results: [FoodItem]?, _ error: NSError?) -> Void) {
        
        let parameters = [
            ParameterKeys.Format: USDAQuery.ParameterValues.JSON,
            ParameterKeys.SearchTerm: query,
            ParameterKeys.DataSource: USDAQuery.ParameterValues.DataSource,
            ParameterKeys.ApiKey: apiKey
        ]
        
        taskForGETMethod(Methods.Search ,parameters as JSONDictionary) { (data, error) in
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard
                let data = data,
                let itemList = self.getFoodItemList(data: data),
                let foodItems = FoodItem.getFoodItems(from: itemList)
            else {
                let userInfo = [NSLocalizedDescriptionKey: "No results returned"]
                completionHandler(nil, NSError(domain: "fetchResults", code: 1, userInfo: userInfo))
                return }

            completionHandler(foodItems, nil)
        }
    }
    
    private func getFoodItemList(data: Any) -> [JSONDictionary]? {
        guard let dictionary = data as? JSONDictionary,
            let list = dictionary[JSONKeys.List] as? JSONDictionary,
            let item = list[JSONKeys.Item] as? [JSONDictionary] else  {
            return nil
        }
      
        return item
    }
    
    public func getFood(for foodItem: FoodItem, completionHandler: @escaping (_ results: Food?, _ error: NSError?) -> Void) {
        
        let ndbno = foodItem.ndbno
        
        let parameters = [
            ParameterKeys.Format: USDAQuery.ParameterValues.JSON,
            ParameterKeys.ApiKey: apiKey,
            ParameterKeys.Ndbno: ndbno
        ]
        
        taskForGETMethod(Methods.Reports, parameters as JSONDictionary) { (data, error) in
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let data = data as? JSONDictionary,
                let parsedData = self.parseFoodReport(dictionary: data),
                let results = Food(dictionary: parsedData)
            else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error parsing the data"]
                completionHandler(nil, NSError(domain: "getFood", code: 1, userInfo: userInfo))
                return
            }

            completionHandler(results, nil)
        }
    }
    
    private func parseFoodReport(dictionary: JSONDictionary) -> JSONDictionary? {
        
        guard let report = dictionary[JSONKeys.Report] as? JSONDictionary,
            let food = report[JSONKeys.Food] as? JSONDictionary else {
                return nil
        }
        
        return food
    }
    
}
