//
//  CustormMarker.swift
//  ParkingApp
//
//  Created by 이민호 on 11/28/23.
//

import NMapsMap
import Foundation


// NMFMarker를 상속받는 사용자 정의 마커 클래스
class CustomMarker: NMFMarker {
    // 마커 터치 이벤트 핸들러
    static var touchHandler: NMFOverlayTouchHandler?
    var markers = [NMFMarker]()
    let dataController = ParkingDataController()
    var delegate : ModalDelegate?
            
    func makeMarker(naverMapView: NMFMapView, lat: Double, long: Double, caption: String) {
        let marker = createMarker(position: NMGLatLng(lat: lat, lng: long), caption: caption)
        marker.mapView = naverMapView
        self.markers.append(marker)
    }
    
    func createMarker(position: NMGLatLng, caption: String) -> CustomMarker {
        let marker = CustomMarker(position: position)
        marker.captionText = caption
        marker.touchHandler = { overlay in
            // 마커 터치 이벤트를 처리하는 사용자 정의 로직을 작성
            print("\(caption)마커 터치 이벤트가 발생했습니다.")
            self.delegate?.presentModal()
            
            return true // 이벤트 소비
        }
        return marker
    }
    
    func removeMarkers() {
        for marker in markers {
            marker.mapView = nil
        }
        markers.removeAll()
    }
    
    func pickMarker(naverMapView: NMFMapView, long: Double, lat: Double) {
        dataController.getDistrict(long: long, lat: lat) { district in
            if let district = district {
                self.dataController.getParkings(district: district) { parkings in
                    if let parkings = parkings {
                        if self.markers.count > 0 {
                            self.removeMarkers()
                        }
                        for parking in parkings {
                            self.makeMarker(naverMapView: naverMapView, lat: parking.lat, long: parking.lng, caption: parking.parkingName)
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
