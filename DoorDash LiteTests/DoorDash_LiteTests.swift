//
//  DoorDash_LiteTests.swift
//  DoorDash LiteTests
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import XCTest
import CoreLocation
@testable import DoorDash_Lite

class DoorDash_LiteTests: XCTestCase {
    
    var apiClient: APIClient!
    var addressViewController: AddressViewController!
    var exploreViewController: ExploreViewController!
    var locationManager: CLLocationManager!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiClient = APIClient()
        locationManager = CLLocationManager()
        addressViewController = AddressViewController()
        exploreViewController = ExploreViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiClient = nil
        locationManager = nil
        addressViewController = nil
        exploreViewController = nil
    }

    // i.e.: permission requests, failure to get location, success case, etc
    /*
     func testExample() {
        // Given: Where we set up all of our dependencies and define our data.
     
        // When: Where we perform the operations that we want to test.
     
        // Then: Where we verify that the correct output was produced.
     }
     */
    
    func testAppLocationServicesOn() {
        
        addressViewController.checkLocationServices()
        XCTAssertTrue(CLLocationManager.authorizationStatus() == .authorizedWhenInUse, "App's Location Services Are Authorized When In Use")
        
    }
    
    // Async test
    func testCanFetchStoresWithLocation() {
        // Given
        let promise = expectation(description: "SUCCESS: Can fetched stores with given location.")
        let latitude = "40.75056096077034"
        let longitude = "-73.98332859396366"
        
        // When
        apiClient.fetchStores(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let stores):
                //Then
                let stores = stores
                XCTAssertNotNil(stores.count > 0, "stores available")
                promise.fulfill()
            case .failure(let error):
                //Then
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testExploreViewRecievedStores() {
        
        XCTAssert(exploreViewController.nearbyStores.count > 0, "SUCCESS: Explore View did recieve stores")
        
    }
    
    

}
