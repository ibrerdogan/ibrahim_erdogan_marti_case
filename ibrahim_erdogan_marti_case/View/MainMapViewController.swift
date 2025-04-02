//
//  MainMapViewController.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import UIKit
import MapKit
import Combine
final class MainMapViewController: UIViewController,MKMapViewDelegate {
    var viewModel: MainMapViewModel
    private var anyCancellable = Set<AnyCancellable>()
    private var selectedAnnotation: CustomAnnotation?
    private lazy var mainMap: MKMapView = {
       let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()
    
    init(viewModel: MainMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mainMap.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        observeCurrentLocation()
        observeShouldAddNewPin()
        viewModel.startTracking()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.requestAuthorization()
    }
    
    private func observeCurrentLocation() {
        viewModel.$currentLocation.sink { [weak self] location in
            guard let strongSelf = self, let location = location else {return}
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
            strongSelf.mainMap.setRegion(region, animated: true)
        }.store(in: &anyCancellable)
    }
    
    private func observeShouldAddNewPin() {
        viewModel.$newPinLocation.sink { [weak self] location in
            guard let strongSelf = self, let location = location else {return}
            let locationModel = CustomLocationModel(address: location.address, location: location.location)
            let annotation = CustomAnnotation(model: locationModel)
                   
            strongSelf.mainMap.addAnnotation(annotation)
        }.store(in: &anyCancellable)
    }
    private func addComponents() {
        view.addSubview(mainMap)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainMap.topAnchor.constraint(equalTo: view.topAnchor),
            mainMap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainMap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainMap.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView?.markerTintColor = .systemBlue
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        guard let customAnnotation = annotationView.annotation as? CustomAnnotation else { return }
        
        if let selected = selectedAnnotation {
            if selected === customAnnotation {
                selected.title = nil
                selectedAnnotation = nil
                mapView.deselectAnnotation(customAnnotation, animated: true)
                return
            } else {
                selected.title = nil
            }
        }
        customAnnotation.title = customAnnotation.locationModel.address
        selectedAnnotation = customAnnotation
    }
}
