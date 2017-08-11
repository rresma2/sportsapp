//
//  SportsFeedAPI.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/25/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class SportsFeedManager {
    static let shared = SportsFeedManager()
    let dateFormatter = DateFormatter()
    
    init() {
        self.dateFormatter.dateFormat = "yyyymmdd"
    }
    
    func getDateStringFrom(date: Date) -> String {
        return self.dateFormatter.string(from: date)
    }
    
    func executeRequestWith<T: SAResponseType>(urlString: String, for date: Date, successResponse: @escaping (T) -> Void, errorResponse: (SAError) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let queryParameters: [String: AnyObject] = [HTTPQueryKey.SportsAPI.date: getDateStringFrom(date: date) as AnyObject]
        
        guard let finalURL = urlByAppendingQueryParameters(url: url, queryParameters: queryParameters) else {
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = HTTPMethod.get.rawValue
        if let basic = "rresma2:sportsapp".data(using: .utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            request.addValue("Basic \(basic))", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue)
            
            let connection = URLSession(configuration: .default)
            connection.dataTask(with: request, completionHandler: { (data, response, error) in
                
            }).resume()
        }
    }
    
    /**
     This creates a new query parameters string from the given NSDictionary.
     */
    
    func stringFor(queryParameters: [String: AnyObject]) -> String {
        var parts = [String]()
        for (key, value) in queryParameters {
            if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                parts.append("\(encodedKey)=\(encodedValue)")
            }
        }
        return parts.joined(separator: "&")
    }
    
    /**
     Creates a new URL by adding the given query parameters.
     @param URL The input URL.
     @param queryParameters The query parameter dictionary to add.
     @return A new NSURL.
     */
    
    func urlByAppendingQueryParameters(url: URL, queryParameters: [String: AnyObject]) -> URL? {
        let urlString = "\(url.absoluteString)?\(stringFor(queryParameters: queryParameters))"
        return URL(string: urlString)
    }
}
