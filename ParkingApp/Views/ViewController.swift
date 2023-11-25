//
//  ViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import UIKit
import SwiftUI
import NMapsMap
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationOverlay: NMFLocationOverlay?    
    let dataController = ParkingDataController()
    var lat: Double = 0
    var long: Double = 0
    var curDistrict = ""
    
    // MARK: - NAVER MAP
    private lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.allowsScrolling = true
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()
    
    // MARK: - 세로고침 버튼
    var configuration = UIButton.Configuration.filled()
    var titleContainer = AttributeContainer()
    
    // MARK: - 새로고침 버튼 실행 함수
    private lazy var refreshBtn = UIButton(configuration: configuration, primaryAction: UIAction(handler: { _ in
        self.dataController.getDistrict(long: self.long , lat: self.lat) { district in
            if let district = district {
                if self.curDistrict != district {
                    self.pickMarker(long: self.long, lat: self.lat)
                }
            } else {
                print("Failed to fetch district.")
            }
        }
    }))
    
    // MARK: - 줌인, 줌아웃 버튼
    lazy var zoomBtn: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(plusBtnTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func plusBtnTapped() {
        let cameraUpdate = NMFCameraUpdate.withZoomIn()
        naverMapView.moveCamera(cameraUpdate)
    }
    
    lazy var zoomOutBtn: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "minus.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(minusBtnTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func minusBtnTapped() {
        let cameraUpdate = NMFCameraUpdate.withZoomOut()
        naverMapView.moveCamera(cameraUpdate)
    }
                                
    override func viewDidLoad() {
        super.viewDidLoad()
        naverMapView.addCameraDelegate(delegate: self)
        configStyle()
        configLocation()
        configCurLocation()
        setLocationData()
    }
    
    func configStyle() {
        titleContainer.font = UIFont.boldSystemFont(ofSize: 20)
        configuration.attributedTitle = AttributedString("refresh", attributes: titleContainer)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        configuration.imagePadding = 10
        configuration.titlePadding = 3
        configuration.title = "현 위치에서 새로고침"
        configuration.image = UIImage(systemName: "arrow.clockwise")
    }
    
    func configLocation() {
        self.view.addSubview(naverMapView)
        self.view.addSubview(refreshBtn)
        self.view.addSubview(zoomBtn)
        self.view.addSubview(zoomOutBtn)
        naverMapView.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        zoomBtn.translatesAutoresizingMaskIntoConstraints = false
        zoomOutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            naverMapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            refreshBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            refreshBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            refreshBtn.heightAnchor.constraint(equalToConstant: 45),
            refreshBtn.widthAnchor.constraint(equalToConstant: 230),
            
            zoomBtn.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),
            zoomBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            zoomOutBtn.topAnchor.constraint(equalTo: zoomBtn.bottomAnchor, constant: 15),
            zoomOutBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])
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
            
            dataController.getDistrict(long: longitude, lat: latitude) { district in
                if let district = district {
                    self.curDistrict = district
                    print("시작위치: \(longitude), \(latitude)")
                    print("시작위치(구): \(self.curDistrict)")
                } else {
                    print("Failed to fetch district.")
                }
            }
                                                            
            // MARK: - 오버레이를 내 위치의 위도,경도로 설정
            guard let locationOverlay = self.locationOverlay else { return }
            locationOverlay.hidden = false
            locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
            locationOverlay.icon = NMFOverlayImage(name: "marker3")
            
        } else {
            print("위치 서비스 Off 상태")
        }
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
                self.dataController.getParkings(district: district) { parkings in
                    if let parkings = parkings {
                        print(parkings)
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

// MARK: - 프리뷰
struct ViewController_PreView: PreviewProvider {
    static var previews: some View {
        ViewController().showPreview()
    }
}

// MARK: - 카메라 컨트롤
extension ViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
       switch reason {
       case -1:
           self.lat = mapView.cameraPosition.target.lat
           self.long = mapView.cameraPosition.target.lng
           print("lng:\(long), lat:\(lat)")
       
           
       default:
           return
       }
    }
}

