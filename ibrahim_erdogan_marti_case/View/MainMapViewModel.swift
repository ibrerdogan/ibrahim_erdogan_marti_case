//
//  MainMapViewModel.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import Foundation
import CoreLocation
final class MainMapViewModel {
    @Published var currentLocation: CLLocation?
    @Published var currentAuthStatus: CLAuthorizationStatus?
    @Published var newPinLocation: CustomLocationModel?
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
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
        locationManager.shouldAddPin = {[weak self] pinLocation in
            guard let strongSelf = self else {return}
            strongSelf.newPinLocation = pinLocation
        }
    }
    
    func requestAuthorization(){
        locationManager.requestAuthorization()
    }
    
    func startTracking() {
        locationManager.startTracking()
    }

}
