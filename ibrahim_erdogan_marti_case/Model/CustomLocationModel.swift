//
//  CustomLocationModel.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 1.04.2025.
//

import CoreLocation
import MapKit
struct CustomLocationModel {
    let address: String
    let location: CLLocation
}

final class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    var title: String?
    let locationModel: CustomLocationModel
    
    init(model: CustomLocationModel) {
        self.coordinate = model.location.coordinate
        self.title = nil 
        self.locationModel = model
    }
}
