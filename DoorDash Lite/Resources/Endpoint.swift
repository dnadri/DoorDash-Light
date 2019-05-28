//
//  Endpoint.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import Foundation

enum Coordinate {
    case latitude
    case longitude
}

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func storeSearch(withLocation latitude: Coordinate = Coordinate.latitude, longitude: Coordinate = Coordinate.longitude) -> Endpoint {
        return Endpoint(
            path: "/search/repositories",
            queryItems: [
                //URLQueryItem(name: "lat", value: Coordinate.latitude),
                //URLQueryItem(name: "lng", value: Coordinate.longitude)
            ]
        )
    }
}

extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.doordash.com/"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}


