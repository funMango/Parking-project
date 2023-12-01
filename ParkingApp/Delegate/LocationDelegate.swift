//
//  LocationDelegate.swift
//  ParkingApp
//
//  Created by 이민호 on 12/1/23.
//

import Foundation
import NMapsMap

protocol LocationDelegate {
    func setLocationData(_ mapView: NMFMapView)
}
