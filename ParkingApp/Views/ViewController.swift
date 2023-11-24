//
//  ViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import UIKit
import NMapsMap
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationOverlay: NMFLocationOverlay?    
    let dataController = ParkingDataController()
    
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
        naverMapView.addCameraDelegate(delegate: self)
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
            
                        
            // MARK: - 카메라 설정
            let latitude = locationManager.location?.coordinate.latitude ?? 0
            let longitude = locationManager.location?.coordinate.longitude ?? 0
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 14)
            naverMapView.moveCamera(cameraUpdate)
            cameraUpdate.animation = .easeIn
            pickMarker(long: longitude, lat: latitude)
                                    
            // MARK: - 오버레이를 내 위치의 위도,경도로 설정
            guard let locationOverlay = self.locationOverlay else { return }
            locationOverlay.hidden = false
            locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
            locationOverlay.icon = NMFOverlayImage(name: "marker3")                                    
            
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
    
    // MARK: - 마커 생성
    func makeMarker(lat: Double, long: Double) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: long)
        marker.mapView = self.naverMapView
    }
    
    func pickMarker(long: Double, lat: Double) {
        dataController.getDistrict(long: long, lat: lat) { district in
            if let district = district {
                print("District: \(district)")
                                   
                self.dataController.getParkings(district: district) { parkings in
                    if let parkings = parkings {
                        
                        for parking in parkings {
                            self.makeMarker(lat: parking.lat, long: parking.lng)
                        }
                    } else {
                        print("Failed to fetch or decode parkings.")
                    }
                }
            } else {
                print("Failed to fetch district.")
            }
        }
    }
}

// MARK: - 카메라 컨트롤
extension ViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    

    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
       switch reason {
       case -1:
           let lat = mapView.cameraPosition.target.lat
           let long = mapView.cameraPosition.target.lng
           print("long: \(long)")
           print("lat: \(lat)")
           
           pickMarker(long: long, lat: lat)
           
       default:
           return
       }
    }
}

