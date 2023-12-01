//
//  LocationManager.swift
//  ParkingApp
//
//  Created by 이민호 on 12/1/23.
//

import UIKit
import SwiftUI
import NMapsMap

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationOverlay: NMFLocationOverlay?
        
    let dataController = ParkingDataController()
    var mapView: NMFMapView?
    var marker: CustomMarker?
    
    var curDistrict = ""
    var latitude: Double = 0
    var longitude: Double = 0
                
    func configLocation(_ mapView: NMFMapView, _ customMarker: CustomMarker) {
        setup(mapView, customMarker)
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate as Any)
            setCamera()
            setOverlay()
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
    func setup(_ mapView: NMFMapView, _ customMarker: CustomMarker) {
        self.mapView = mapView
        self.marker = customMarker
        self.locationOverlay = self.mapView?.locationOverlay
        configCurLocation()
    }
          
    func configCurLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - 카메라 설정
    func setCamera() {
        self.latitude = locationManager.location?.coordinate.latitude ?? 0
        self.longitude = locationManager.location?.coordinate.longitude ?? 0
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 14)
        mapView?.moveCamera(cameraUpdate)
        cameraUpdate.animation = .easeIn
        
        if let mapView = self.mapView {
            self.marker?.pickMarker(naverMapView: mapView, long: longitude, lat: latitude)
        }
        printCurLocation(longitude, latitude)
    }
    
    // MARK: - 현재위치 프린트
    func printCurLocation(_ longitude: Double, _ latitude: Double) {
        dataController.getDistrict(long: longitude, lat: latitude) { district in
            if let district = district {
                self.curDistrict = district
                print("시작위치: \(longitude), \(latitude)")
                print("시작위치(구): \(self.curDistrict)")
            } else {
                print("Failed to fetch district.")
            }
        }
    }
    
    // MARK: - 오버레이를 내 위치의 위도,경도로 설정
    func setOverlay() {
        guard let locationOverlay = self.locationOverlay else { return }
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
        locationOverlay.icon = NMFOverlayImage(name: "marker3")
    }
}

