//
//  ZoomButton.swift
//  ParkingApp
//
//  Created by 이민호 on 12/2/23.
//

import UIKit
import NMapsMap

enum Zoom {
    case ZoomIn
    case ZoomOut
}

class ZoomButton: UIButton {
    private var action: (() -> Void)?
    private var btnImg: String?
    private var mapView: NMFMapView?
    private var zoom: Zoom?
    
    init(_ btnImg: String, _ mapView: NMFMapView, _ zoom: Zoom) {
        super.init(frame: .zero)
        self.mapView = mapView
        self.btnImg = btnImg
        self.zoom = zoom
        config()
    }
    
    func config() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: btnImg ?? "", withConfiguration: imageConfig)
        self.setImage(image, for: .normal)
        self.tintColor = .systemBlue
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        let cameraUpdate: NMFCameraUpdate
        
        switch zoom{
            case .ZoomIn:
                cameraUpdate = NMFCameraUpdate.withZoomIn()
            case .ZoomOut:
                cameraUpdate = NMFCameraUpdate.withZoomOut()
            default:
                fatalError("줌 기능을 사용할 수 없습니다.")
        }
                
        mapView?.moveCamera(cameraUpdate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
