//
//  ExploreViewController.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    weak var tableView: UITableView!
    var nearbyStores = [Store]()
    
    lazy var placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.bold)
        label.textAlignment = .center
        label.text = "No stores nearby.\nChoose a new location."
        return label
    }()
    
    func addTitleLabel() {
        view.addSubview(placeholderTitleLabel)
        NSLayoutConstraint.activate([
            placeholderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    func removeTitleLabel() {
        placeholderTitleLabel.removeFromSuperview()
    }
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        self.tableView = tableView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "DoorDash"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 255.0/255.0, green: 42.0/255.0, blue: 14.0/255.0, alpha: 1.0)]
        
        if nearbyStores.count == 0 {
            addTitleLabel()
        } else {
            removeTitleLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "nav-address"), style: .plain, target: self, action: #selector(self.handleMapButton))

        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = mapBarButton
        
        handleMapButton()
        setupTableView()
        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: Constants.storeCellReuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func handleMapButton() {
        let addressViewController = AddressViewController()
        addressViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addressViewController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let rootController = appDelegate?.window?.rootViewController
        rootController?.present(navigationController, animated: true, completion: nil)
    }

}

// - MARK: ExploreViewDelegate
extension ExploreViewController: AddressViewDelegate {
    
    func didReceiveStores(stores: [Store]) {
        self.nearbyStores = stores
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}

// - MARK: UITableViewDataSource
extension ExploreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storeCell = tableView.dequeueReusableCell(withIdentifier: Constants.storeCellReuseIdentifier, for: indexPath) as! StoreTableViewCell
        let store = nearbyStores[indexPath.row]
        storeCell.configure(with: store)
        return storeCell
    }

}

// - MARK: UITableViewDelegate
extension ExploreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
