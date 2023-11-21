//
//  ViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import UIKit
import NMapsMap

class ViewController: UIViewController {
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.allowsScrolling = true
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        self.view.addSubview(naverMapView)
        naverMapView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            naverMapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
}

