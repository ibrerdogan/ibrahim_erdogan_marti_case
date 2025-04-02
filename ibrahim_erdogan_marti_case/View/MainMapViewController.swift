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
    
    private lazy var startButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Tracking", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(startTracking), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stop Tracking", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(stopTracking), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(deleteAllPins), for: .touchUpInside)
        return button
    }()
    
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.requestAuthorization()
        viewModel.getSavedPins()
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
        mainMap.addSubview(startButton)
        mainMap.addSubview(stopButton)
        mainMap.addSubview(deleteButton)
        view.addSubview(mainMap)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainMap.topAnchor.constraint(equalTo: view.topAnchor),
            mainMap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainMap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainMap.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            startButton.leadingAnchor.constraint(equalTo: mainMap.leadingAnchor, constant: 20),
            startButton.bottomAnchor.constraint(equalTo: mainMap.bottomAnchor, constant: -20),
            
            stopButton.trailingAnchor.constraint(equalTo: mainMap.trailingAnchor, constant: -20),
            stopButton.bottomAnchor.constraint(equalTo: mainMap.bottomAnchor, constant: -20),
            
            deleteButton.topAnchor.constraint(equalTo: startButton.topAnchor, constant: 0),
            deleteButton.trailingAnchor.constraint(equalTo: stopButton.leadingAnchor)
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
    
    @objc
    func startTracking() {
        viewModel.startTracking()
    }
    
    @objc
    func stopTracking() {
        viewModel.stopTracking()
    }
    
    @objc
    func deleteAllPins() {
        viewModel.deleteAllPins()
        mainMap.removeAnnotations(mainMap.annotations)
    }
    
    
}
