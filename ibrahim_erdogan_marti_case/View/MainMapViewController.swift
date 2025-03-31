//
//  MainMapViewController.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import UIKit
import MapKit
final class MainMapViewController: UIViewController {
    var viewModel: MainMapViewModel
    
    
    private lazy var mainMap: MKMapView = {
       let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
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
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
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
