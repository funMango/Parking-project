//
//  ParkingLots.swift
//  ParkingApp
//
//  Created by 이민호 on 11/22/23.
//

import Foundation

enum UrlError : Error {
    case inavalidUrl
    case invalidResponse
    case invalidData
}

class ParkingDataController {
    func getParkingLots () async throws -> ParkingLot {
        let endPoint = API.BASE_URL
        
        guard let url = URL(string: endPoint) else { throw UrlError.inavalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
                
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw UrlError.invalidResponse
        }
               
        do {
            print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to UTF-8 string")")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let parkingInfo = try decoder.decode(ParkingLot.self, from: data)
            return parkingInfo
        } catch {
            print(error)
            throw UrlError.invalidData
        }
    }
}
