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

    // 마커 생성 함수
    class func createMarker(position: NMGLatLng, caption: String) -> CustomMarker {
        let marker = CustomMarker(position: position)
        marker.captionText = caption
        marker.touchHandler = { overlay in
            // 마커 터치 이벤트를 처리하는 사용자 정의 로직을 작성
            print("\(caption)마커 터치 이벤트가 발생했습니다.")
            return true // 이벤트 소비
        }
        return marker
    }
}
