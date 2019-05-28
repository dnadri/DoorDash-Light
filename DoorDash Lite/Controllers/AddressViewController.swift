//
//  AddressViewController.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressViewController: UIViewController {
    
    let apiClient = APIClient()
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var stores = [Store]()
    weak var delegate: AddressViewDelegate?
    
    lazy var pinImageView: UIImageView = {
        let pin = UIImageView(image: #imageLiteral(resourceName: "location-pin"))
        pin.translatesAutoresizingMaskIntoConstraints = false
        pin.contentMode = .center
        pin.backgroundColor = .clear
        return pin
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
        label.numberOfLines = 1
        return label
    }()
    
    let confirmAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 255.0/255.0, green: 42.0/255.0, blue: 14.0/255.0, alpha: 1.0)
        button.tintColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.medium)
        button.setTitle("Confirm Address", for: .normal)
        button.addTarget(self, action: #selector(confirmAddress), for: .touchUpInside)
        return button
    }()
    
    private func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(mapView)
        self.view.addSubview(pinImageView)
        self.view.addSubview(confirmAddressButton)
        self.view.addSubview(addressLabel)

        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "Choose an Address"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        checkLocationServices()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        mapView.delegate = self
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorizationStatus()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnCurrentLocation()
            locationManager.startUpdatingLocation()
        case .restricted:
            showAlert(title: "This app is not authorized to use location services.", message: "The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.")
        case .notDetermined:
            // The user has not yet made a choice regarding whether this app can use location services.
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            showAlert(title: "Location Services Disabled", message: "The use of location services for this app or location services are currently disabled. You must go to your Settings to enable the app to access your location.")
        case .authorizedAlways:
            break
        }
    }
    
    func centerViewOnCurrentLocation() {
        if let location = locationManager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLayout() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: addressLabel.topAnchor)
            ])

        NSLayoutConstraint.activate([
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -pinImageView.bounds.height/2)
            ])
        
        NSLayoutConstraint.activate([
            confirmAddressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmAddressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmAddressButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmAddressButton.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: confirmAddressButton.topAnchor),
            addressLabel.heightAnchor.constraint(equalToConstant: 55)
            ])
    }
    
    func updateAddressLabel() {
        guard let location = userLocation else { return }
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) {
            placemarks, error -> Void in
            guard let placeMark = placemarks?.first else { return }
            guard let number = placeMark.subThoroughfare, let street = placeMark.thoroughfare else {
                DispatchQueue.main.async { [weak self] in
                    self?.addressLabel.text = "Address Not Found"
                    self?.confirmAddressButton.isEnabled = false
                    self?.confirmAddressButton.backgroundColor = .lightGray
                }
                return
            }
            DispatchQueue.main
            DispatchQueue.main.async { [weak self] in
                self?.addressLabel.text = "\(number) \(street)"
                self?.confirmAddressButton.isEnabled = true
                self?.confirmAddressButton.backgroundColor = UIColor(red: 255.0/255.0, green: 42.0/255.0, blue: 14.0/255.0, alpha: 1.0)
            }
        }
    }
    
    @objc func confirmAddress() {
        guard let location = userLocation else { return }
        // Pass the location to other view controller
        apiClient.fetchStores(latitude: "\(location.latitude)", longitude: "\(location.longitude)") { [weak self] result in
            switch result {
            case .failure(let error):
                print("ERROR: ", error.localizedDescription)
            case .success(let stores):
                self?.delegate?.didReceiveStores(stores: stores)
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }

}

// - MARK: CLLocationManagerDelegate
extension AddressViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        userLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error.localizedDescription)
    }
    
}

// - MARK: MKMapViewDelegate
extension AddressViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.locationManager.stopUpdatingLocation()
  
        userLocation = mapView.centerCoordinate
        updateAddressLabel()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
}
