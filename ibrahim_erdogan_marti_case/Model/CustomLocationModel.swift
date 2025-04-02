//
//  CustomLocationModel.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 1.04.2025.
//

import CoreLocation
import MapKit
import CoreLocation

struct CustomLocationModel: Codable {
    let address: String
    let location: CLLocation
    
    enum CodingKeys: String, CodingKey {
        case address
        case latitude
        case longitude
    }
    
    init(address: String, location: CLLocation) {
        self.address = address
        self.location = location
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(location.coordinate.latitude, forKey: .latitude)
        try container.encode(location.coordinate.longitude, forKey: .longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let address = try container.decode(String.self, forKey: .address)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        self.init(address: address, location: location)
    }
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
