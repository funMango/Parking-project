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

class ViewController: UIViewController, UISheetPresentationControllerDelegate, ModalDelegate {
    var locationOverlay: NMFLocationOverlay?
    let dataController = ParkingDataController()
    var locationManager = LocationManager()
    let customMarker = CustomMarker()
    var lat: Double = 0
    var long: Double = 0
    var curDistrict = ""
    
    // MARK: - NAVER MAP
    lazy var naverMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.allowsScrolling = true
        return mapView
    }()
    
    // MARK: - 세로고침 버튼    
    lazy var refreshBtn: RefreshButton = {
        return RefreshButton(title: "현재 위치에서 다시검색") { [weak self] in
            guard let self = self else { return }
            
            self.dataController.getDistrict(long: self.long , lat: self.lat) { district in
                if let district = district, self.curDistrict != district {
                    self.customMarker.pickMarker(naverMapView: self.naverMapView, long: self.long, lat: self.lat)
                } else {
                    print("지역 정보를 가져오는데 실패했습니다.")
                }
            }
        }
    }()
        
    // MARK: - 줌인, 줌아웃 버튼
    lazy var zoomInBtn = ZoomButton("plus.circle", self.naverMapView, .ZoomIn)
    lazy var zoomOutBtn = ZoomButton("minus.circle", self.naverMapView, .ZoomOut)
                
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        customMarker.delegate = self
        naverMapView.addCameraDelegate(delegate: self)
        configLocation()
        locationManager.configLocation(self.naverMapView, self.customMarker)
    }
    
    // MARK: - 모달창 생성
    func presentModal(_ parking: Parking) {
        let vc = SmallModalView(parking: parking)
        vc.view.backgroundColor = .white
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            
            //지원할 크기 지정
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.4
                },
                .custom { context in
                    return context.maximumDetentValue
                }
            ]
            //크기 변하는거 감지
            sheet.delegate = self
           
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
            
            //처음 크기 지정 (기본 값은 가장 작은 크기)
            //sheet.selectedDetentIdentifier = .large
            
            //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        present(vc, animated: true, completion: nil)
    }
         
    func configLocation() {
        self.view.addSubview(naverMapView)
        self.view.addSubview(refreshBtn)
        self.view.addSubview(zoomInBtn)
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
        
        zoomInBtn.snp.makeConstraints{
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-80)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        zoomOutBtn.snp.makeConstraints{
            $0.top.equalTo(zoomInBtn.snp.bottom).offset(15)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
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

