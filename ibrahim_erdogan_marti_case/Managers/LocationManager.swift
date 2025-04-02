//
//  LocationManager.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var didUpdateLocation : (Result<CLLocation,Error>) -> () = { _ in}
    var didupdateLocationAuthStatus: (CLAuthorizationStatus) -> () = { _ in}
    var shouldAddPin: (CustomLocationModel) -> () = { _ in}
    private let locationManager = CLLocationManager()
    private var lastPinLocation: CLLocation?
    private var geocoderManager = GeocoderManager()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func requestAuthorization() {
        if locationManager.authorizationStatus != .authorizedWhenInUse || locationManager.authorizationStatus != .authorizedAlways {
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
        didUpdateLocation(Result.success(location))
        shouldAddNewPin(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didUpdateLocation(Result.failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didupdateLocationAuthStatus(manager.authorizationStatus)
    }
    
    private func shouldAddNewPin(_ location: CLLocation) {
        guard let lastPin = lastPinLocation else {
            
            geocoderManager.getAddressForLocation(location) {[weak self] address in
                guard let strongSelf = self, let address = address else {return}
                strongSelf.updateAddPin(CustomLocationModel(address: address, location: location))
            }
            return
        }
        
        let distance = lastPin.distance(from: location)
        if distance >= 100 {
            geocoderManager.getAddressForLocation(location) {[weak self] address in
                guard let strongSelf = self, let address = address else {return}
                strongSelf.updateAddPin(CustomLocationModel(address: address, location: location))
            }
        }
        
    }
    
    private func updateAddPin(_ location: CustomLocationModel) {
        shouldAddPin(location)
        lastPinLocation = location.location
    }
}
