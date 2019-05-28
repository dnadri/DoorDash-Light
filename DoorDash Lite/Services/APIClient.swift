//
//  APIClient.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import Foundation

/**
 The result types for the API response.
 
 - success: The data from the API fetch is passed
 - failure: The Error type is passed
 */
enum Result {
    case success([Store])
    case failure(Error)
}

// RootURL: https://api.doordash.com/
// v1/store_search/?lat=37.42274&lng=-122.139956
// EX: https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956
class APIClient {
    
    /**
     Downloads and parses the JSON (store objects available for delivery at the given location) at the Endpoint URL.
     
     - completion: Uses a completion handler to identify Result type (success/failure) and handles appropriately
     */
    func fetchStores(latitude: String, longitude: String, completion: @escaping ((Result) -> Void)) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.doordash.com"
        components.path = "/v1/store_search/"
        components.queryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lng", value: longitude)
        ]
        
        guard let url = components.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, _, error in
            
            if let error = error {
                print("Error: Failed to fetch data from url. [\(error.localizedDescription)]")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Data not available.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let stores = try decoder.decode([Store].self, from: data)
                completion(.success(stores))
                
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        
        task.resume()
        
    }
    
}
