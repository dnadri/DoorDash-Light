//
//  FavoritesViewController.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    lazy var placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.bold)
        label.textAlignment = .center
        label.text = "No Favorites\n😕"
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 255.0/255.0, green: 42.0/255.0, blue: 14.0/255.0, alpha: 1.0)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(placeholderTitleLabel)
        NSLayoutConstraint.activate([
            placeholderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    
}

