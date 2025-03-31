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
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        observeAuthStatus()
    }
    
    func observeAuthStatus() {
        locationManager.didupdateLocationAuthStatus = { [weak self] status in
            guard let strongSelf = self else {return}
            strongSelf.currentAuthStatus = status
        }
    }
    
    func requestAuthorization(){
        locationManager.requestAuthorization()
    }

}
