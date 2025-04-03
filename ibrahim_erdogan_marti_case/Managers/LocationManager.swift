//
//  LocationManager.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import Foundation
import CoreLocation
protocol LocationManagerProtocol {
    var didUpdateLocationAuthStatus: ((CLAuthorizationStatus) -> Void)? { get set }
    var addNewLocationToMap: ((CustomLocationModel) -> Void)? { get set }
    var didUpdateLocation : ((Result<CLLocation,Error>) -> Void)? { get set }
    var geocoderManager: GeocoderManagerProtocol {get set}
    var distance: Double {get set}
    
    func requestAuthorization()
    func startTracking()
    func stopTracking()
}

final class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    
    var didUpdateLocationAuthStatus: ((CLAuthorizationStatus) -> Void)?
    var addNewLocationToMap: ((CustomLocationModel) -> Void)?
    var didUpdateLocation : ((Result<CLLocation,Error>) -> Void)?
    var geocoderManager: GeocoderManagerProtocol
    var distance: Double
    
    private let locationManager = CLLocationManager()
    private var lastPinLocation: CLLocation?
    
    init(geocoderManager: GeocoderManagerProtocol, distance: Double) {
        self.distance = distance
        self.geocoderManager = geocoderManager
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func requestAuthorization() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func startTracking() {
        locationManager.startUpdatingLocation()
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        didUpdateLocation?(Result.success(location))
        handleNewPin(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didUpdateLocation?(Result.failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didUpdateLocationAuthStatus?(manager.authorizationStatus)
    }
    
    private func handleNewPin(_ location: CLLocation) {
        guard let lastPin = lastPinLocation else {
            addPin(for: location)
            return
        }
        
        let distance = lastPin.distance(from: location)
        if distance >= self.distance {
            addPin(for: location)
        }
    }
    
    private func addPin(for location: CLLocation) {
        geocoderManager.getAddressForLocation(location) { [weak self] address in
            guard let self = self, let address = address else { return }
            let locationModel = CustomLocationModel(address: address, location: location)
            self.addNewLocationToMap?(locationModel)
            self.lastPinLocation = location
        }
    }
}

