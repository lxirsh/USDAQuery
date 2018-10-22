//
//  USDAQuery.swift
//  USDAWebservice
//
//  Created by Lance Hirsch on 4/7/17.
//  Copyright © 2017 Lance Hirsch. All rights reserved.
//

import Foundation

typealias JSONDictionary = Dictionary<String, Any>

private class USDAQueryConfiguration {
    var apiKey: String?
}

final public class USDAQuery: NSObject {
    
    var apiKey = ""
    
    public static let sharedInstance = USDAQuery()
    private static let config = USDAQueryConfiguration()
    
    public class func setup(apiKey: String) {
        USDAQuery.config.apiKey = apiKey
    }
    
    private override init() {
        
        guard let apiKey = USDAQuery.config.apiKey else {
            print("Error -- you must call USDAQuery.setup before accessing USDAQuery")
            return
        }
        
        self.apiKey = apiKey
    }
    
    var session = URLSession.shared
    
    // MARK: GET
    @discardableResult func taskForGETMethod(_ method: String, _ parameters: JSONDictionary, completionHandlerForGet: @escaping (_ data: Any?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var parameters = parameters
        
        // Build the URL and configure the request
        let url = urlFromParameters(parameters, withPathExtention: method)
        print(url)
        let request = URLRequest(url: url)
        
        // Make the request
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            if let error = error {
                sendError(error.localizedDescription)
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (in completion handler)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
            
        })
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // Substitute the key for the value that is contained within the method name
    private func subtituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // Return a useable Foundation object from raw JSON data
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "converDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult as AnyObject?, nil)
    }
    
    // Create a URL from parameters
    fileprivate func urlFromParameters(_ parameters: JSONDictionary, withPathExtention: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = USDAQuery.URLConstants.USDAScheme
        components.host = USDAQuery.URLConstants.USDAHost
        components.path = USDAQuery.URLConstants.ApiPath + (withPathExtention ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
        
    }
}
