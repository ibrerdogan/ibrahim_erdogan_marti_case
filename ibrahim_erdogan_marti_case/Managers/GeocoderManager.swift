//
//  GeocoderManager.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 1.04.2025.
//

import CoreLocation
final class GeocoderManager {
    private let geocoder = CLGeocoder()
    func getAddressForLocation(_ location: CLLocation,completion: @escaping (String?) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Adres çözümleme hatası: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let placemark = placemarks?.first {
                let address = "\(placemark.thoroughfare ?? "Bilinmeyen Cadde"), \(placemark.locality ?? "Bilinmeyen Şehir")"
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
}
