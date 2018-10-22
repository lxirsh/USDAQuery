//
//  Constants.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/7/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

extension USDAQuery {
    
    // MARK: URL Constants
    struct URLConstants {
        
        static let USDAScheme = "https"
        static let USDAHost = "api.nal.usda.gov"
        static let ApiPath = "/ndb"
    }
    
    // Methods
    struct Methods {
        
        static let Search = "/search"
        static let Reports = "/reports"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SearchTerm = "q"
        static let DataSource = "ds"
        static let Format = "format"
        static let Ndbno = "ndbno"
        
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        
        static let ApiKey = ""
        static let DataSource = "Standard Reference"
        static let JSON = "json"
        
    }
    
    // MARK: JSON Keys
    struct JSONKeys {
        
        static let List = "list"
        static let Report = "report"
        static let Food = "food"
        static let Ndbno = "ndbno"
        static let Item = "item"
    }
    
}
