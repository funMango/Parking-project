//
//  CurrentViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import Foundation
import CoreLocation
import UIKit

class CurrentViewController: UIViewController {
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
            setLocationData()
    }

    // MARK: - 내 위치의 위도, 경도 세팅
    func setLocationData() {
        // locationManager 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // 위도, 경도 가져오기
        let latitude = locationManager.location?.coordinate.latitude ?? 0
        let longitude = locationManager.location?.coordinate.longitude ?? 0
    }
}
