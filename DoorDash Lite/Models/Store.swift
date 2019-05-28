//
//  Store.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//
/*
 Important Fields:
 - id: primary key
 - name: name of the store
 - description: description of the store
 - delivery_fee: the cost of delivery, in cents
 - cover_img_url: URL to icon image of the store
 - asap_time: estimated delivery time, in minutes
 */

import Foundation

struct Store: Codable {
    let id: Int
    let name: String
    let description: String
    let deliveryFee: Int
    let coverImgURL: String
    let asapTime: Int?
    
    // Here we customize key names since the API contains snake-case
    private enum CodingKeys: String, CodingKey {
        case id, name, description
        case deliveryFee = "delivery_fee"
        case coverImgURL = "cover_img_url"
        case asapTime = "asap_time"
    }
    
}
