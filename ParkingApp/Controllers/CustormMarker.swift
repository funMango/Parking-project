//
//  CustormMarker.swift
//  ParkingApp
//
//  Created by 이민호 on 11/28/23.
//

import NMapsMap
import Foundation

class CustomMarker: NMFMarker {
    static var touchHandler: NMFOverlayTouchHandler?
    var markers = [NMFMarker]()
    let dataController = ParkingDataController()
    var delegate : ModalDelegate?
    
    func pickMarker(naverMapView: NMFMapView, long: Double, lat: Double) {
        dataController.getDistrict(long: long, lat: lat) { district in
            if let district = district {
                self.dataController.getParkings(district: district) { parkings in
                    if let parkings = parkings {
                        if self.markers.count > 0 {
                            self.removeMarkers()
                        }
                        for parking in parkings {
                            self.makeMarker(parking: parking, naverMapView: naverMapView, lat: parking.lat, long: parking.lng, caption: parking.parkingName)
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
            
    func makeMarker(parking: Parking, naverMapView: NMFMapView, lat: Double, long: Double, caption: String) {
        let marker = createMarker(parking: parking, position: NMGLatLng(lat: lat, lng: long), caption: caption)
        marker.mapView = naverMapView
        self.markers.append(marker)
    }
    
    func createMarker(parking: Parking, position: NMGLatLng, caption: String) -> CustomMarker {
        let marker = CustomMarker(position: position)
        marker.captionText = caption
        marker.touchHandler = { overlay in
            print("\(caption)마커 터치 이벤트가 발생했습니다.")
            self.delegate?.presentModal(parking)
            return true
        }
        return marker
    }
    
    func removeMarkers() {
        for marker in markers {
            marker.mapView = nil
        }
        markers.removeAll()
    }
}
