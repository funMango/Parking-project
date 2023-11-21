//
//  ViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import UIKit
import NMapsMap

// https://jkim68888.tistory.com/5

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationOverlay: NMFLocationOverlay?
    
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.allowsScrolling = true
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configCurLocation()
        setLocationData()
    }
    
    func configCurLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setLocationData() {
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate as Any)
            
            
            // 카메라 설정
            let latitude = locationManager.location?.coordinate.latitude ?? 0
            let longitude = locationManager.location?.coordinate.longitude ?? 0
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 14)
            naverMapView.moveCamera(cameraUpdate)
            cameraUpdate.animation = .easeIn
            
            
            // 오버레이를 내 위치의 위도,경도로 설정
            guard let locationOverlay = self.locationOverlay else { return }
            locationOverlay.hidden = false
            locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
            locationOverlay.icon = NMFOverlayImage(name: "marker3")
                
            
            // 마커 설정
//            let marker = NMFMarker()
//            marker.position = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0,
//                                        lng: locationManager.location?.coordinate.longitude ?? 0)
//            marker.mapView = naverMapView
            
            
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

