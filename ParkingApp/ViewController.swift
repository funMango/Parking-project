//
//  ViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import UIKit
import NMapsMap

class ViewController: UIViewController, CLLocationManagerDelegate {
    let currentManager = CurrentViewController()
    
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
        configCurLocation()
    }
    
    func configCurLocation() {
        currentManager.locationManager.delegate = self
        currentManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currentManager.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            currentManager.locationManager.startUpdatingLocation()
            print(currentManager.locationManager.location?.coordinate as Any)
            
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentManager.locationManager.location?.coordinate.latitude ?? 0,
                                                                   lng: currentManager.locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            naverMapView.moveCamera(cameraUpdate)
            
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: currentManager.locationManager.location?.coordinate.latitude ?? 0,
                                        lng: currentManager.locationManager.location?.coordinate.longitude ?? 0)
            marker.mapView = naverMapView
        } else {
            print("위치 서비스 Off 상태")
        }
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

