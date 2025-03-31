//
//  MainMapViewController.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import UIKit
import MapKit
import Combine
final class MainMapViewController: UIViewController {
    var viewModel: MainMapViewModel
    private var anyCancellable = Set<AnyCancellable>()
    
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
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "📍 Pin"
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
}
