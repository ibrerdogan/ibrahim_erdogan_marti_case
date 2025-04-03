//
//  MainMapViewModel.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import Foundation
import CoreLocation
final class MainMapViewModel {
    @Published var currentAuthStatus: CLAuthorizationStatus?
    @Published var newPinLocation: CustomAnnotation?
    private var locationManager: LocationManager
    private var userDefaultManager: UserDefaultsManager
    var selectedAnnotation: CustomAnnotation?
    init(locationManager: LocationManager, userDefaultManager: UserDefaultsManager) {
        self.locationManager = locationManager
        self.userDefaultManager = userDefaultManager
        observeAuthStatus()
        observeShouldAddNewPin()
    }
    
    func observeAuthStatus() {
        locationManager.didupdateLocationAuthStatus = { [weak self] status in
            guard let strongSelf = self else {return}
            strongSelf.currentAuthStatus = status
        }
    }
    
    func observeShouldAddNewPin() {
        locationManager.addNewLocationToMap = {[weak self] pinLocation in
            guard let strongSelf = self else {return}
            strongSelf.newPinLocation = strongSelf.createCustomAnnotation(pinLocation: pinLocation)
            strongSelf.userDefaultManager.add(pinLocation)
        }
    }
    
    func getSavedPins() {
        let pins = userDefaultManager.fetchAll()
        pins.forEach { [weak self] pinLocation in
            guard let strongSelf = self else {return}
            strongSelf.newPinLocation = strongSelf.createCustomAnnotation(pinLocation: pinLocation)
        }
    }
    
    private func createCustomAnnotation(pinLocation: CustomLocationModel) -> CustomAnnotation{
        let locationModel = CustomLocationModel(address: pinLocation.address, location: pinLocation.location)
        let annotation = CustomAnnotation(model: locationModel)
        return annotation
    }
    
    func requestAuthorization(){
        locationManager.requestAuthorization()
    }
    
    func startTracking() {
        locationManager.startTracking()
    }
    
    func stopTracking() {
        locationManager.stopTracking()
    }
    
    func deleteAllPins() {
        userDefaultManager.removeAll()
    }

}
