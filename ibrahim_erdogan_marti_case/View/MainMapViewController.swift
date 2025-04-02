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
    
    private lazy var startButton: CustomButton = {
       let button = CustomButton(title: "Start Tracking",
                                 icon: UIImage(systemName: "play.fill"),
                                 backgroundColor: .systemBlue)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startTracking), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = CustomButton(title: "Stop Tracking",
                                  icon: UIImage(systemName: "stop.fill"),
                                  backgroundColor: .systemBlue)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stopTracking), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = CustomButton(title: "Delete",
                                  icon: UIImage(systemName: "trash.fill"),
                                  backgroundColor: .systemBlue)
        button.translatesAutoresizingMaskIntoConstraints = false
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
            startButton.bottomAnchor.constraint(equalTo: mainMap.bottomAnchor, constant: -50),
            
            stopButton.trailingAnchor.constraint(equalTo: mainMap.trailingAnchor, constant: -20),
            stopButton.bottomAnchor.constraint(equalTo: mainMap.bottomAnchor, constant: -50),
            
            deleteButton.topAnchor.constraint(equalTo: mainMap.topAnchor, constant: 50),
            deleteButton.trailingAnchor.constraint(equalTo: stopButton.trailingAnchor)
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
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.canShowCallout = false
        annotationView?.markerTintColor = .systemBlue
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        guard let customAnnotation = annotationView.annotation as? CustomAnnotation else { return }
        
        if let selected = viewModel.selectedAnnotation {
            if selected === customAnnotation {
                selected.title = nil
                viewModel.selectedAnnotation = nil
                mapView.deselectAnnotation(customAnnotation, animated: true)
                return
            } else {
                selected.title = nil
            }
        }
        customAnnotation.title = customAnnotation.locationModel.address
        viewModel.selectedAnnotation = customAnnotation
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
