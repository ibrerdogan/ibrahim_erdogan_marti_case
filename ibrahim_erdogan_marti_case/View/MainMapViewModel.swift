//
//  MainMapViewModel.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import Foundation
import CoreLocation

protocol MainMapViewModelDelegate: AnyObject {
    func didUpdateNewPin(_ annotation: CustomAnnotation?)
}

protocol MainMapViewModelProtocol: AnyObject {
    var delegate: MainMapViewModelDelegate? { get set }
    var selectedAnnotation: CustomAnnotation? {get set}
    func observeAuthStatus()
    func observeShouldAddNewPin()
    func getSavedPins()
    func requestAuthorization()
    func startTracking()
    func stopTracking()
    func deleteAllPins()
}

final class MainMapViewModel: MainMapViewModelProtocol {
    var delegate: MainMapViewModelDelegate?
    private var currentAuthStatus: CLAuthorizationStatus?
    private(set) var newPinLocation: CustomAnnotation? {
        didSet {
            delegate?.didUpdateNewPin(newPinLocation)
        }
    }
    private var locationManager: LocationManagerProtocol
    private var userDefaultManager: UserDefaultsManagerProtocol
    
    var selectedAnnotation: CustomAnnotation?
    
    init(locationManager: LocationManagerProtocol, userDefaultManager: UserDefaultsManagerProtocol) {
        self.locationManager = locationManager
        self.userDefaultManager = userDefaultManager
        observeAuthStatus()
        observeShouldAddNewPin()
    }
    
    func observeAuthStatus() {
        locationManager.didUpdateLocationAuthStatus = { [weak self] status in
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
