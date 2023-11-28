//
//  ViewController.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import UIKit
import SwiftUI
import SnapKit
import NMapsMap
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var locationOverlay: NMFLocationOverlay?    
    let dataController = ParkingDataController()
    let customMarker = CustomMarker()
    var parkings = [Parking]()
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
                    self.customMarker.pickMarker(naverMapView: self.naverMapView, long: self.long, lat: self.lat)
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
        
        naverMapView.snp.makeConstraints{ make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        refreshBtn.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
            make.height.equalTo(45)
            make.width.equalTo(230)
        }
        
        zoomBtn.snp.makeConstraints{
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-80)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        zoomOutBtn.snp.makeConstraints{
            $0.top.equalTo(zoomBtn.snp.bottom).offset(15)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
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
            customMarker.pickMarker(naverMapView: self.naverMapView, long: longitude, lat: latitude)
            
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
           // mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
           self.lat = mapView.cameraPosition.target.lat
           self.long = mapView.cameraPosition.target.lng
           print("lng:\(long), lat:\(lat)")
           debugPrint(mapView.cameraPosition)
       
           
       default:
           return
       }
    }
}

