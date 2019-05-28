//
//  Protocols.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import Foundation

protocol AddressViewDelegate: class {
    func didReceiveStores(stores: [Store])
}
