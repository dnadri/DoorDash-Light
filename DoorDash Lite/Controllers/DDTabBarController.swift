//
//  DDTabBarController.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import UIKit

class DDTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(red: 255.0/255.0, green: 42.0/255.0, blue: 14.0/255.0, alpha: 1.0)

        let navigationController = UINavigationController(rootViewController: ExploreViewController())
        navigationController.tabBarItem = UITabBarItem(title: "Explore", image: #imageLiteral(resourceName: "tab-home-gray"), selectedImage: #imageLiteral(resourceName: "tab-home-red"))
        
        let favoriteNavigationController = UINavigationController(rootViewController: FavoritesViewController())
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "tab-star-gray"), selectedImage: #imageLiteral(resourceName: "tab-star-red"))
        
        
        let tabBarViewControllers = [navigationController, favoriteNavigationController]
        viewControllers = tabBarViewControllers
        
    }

}
