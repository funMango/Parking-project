//
//  Location.swift
//  ParkingApp
//
//  Created by 이민호 on 11/21/23.
//

import Foundation

class Location {
    
    func getURL(with local: String) -> String {
        return "http://openapi.seoul.go.kr:8088/59416c63596d696e3535456377774b/json/GetParkingInfo/1/1000/\(local)"
    }
}


