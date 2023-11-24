//
//  ParkingLots.swift
//  ParkingApp
//
//  Created by 이민호 on 11/22/23.
//

import Foundation
import NMapsMap
import Alamofire
import SwiftyJSON

enum UrlError : Error {
    case inavalidUrl
    case invalidResponse
    case invalidData
}

class ParkingDataController {
    
    // MARK: - 공영주차장 정보를 가져오는 기능 - 사용X, 안됨
    func getApiData<T: Codable>(url: String) async throws -> T {
        guard let url = URL(string: url) else { throw UrlError.inavalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
                
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw UrlError.invalidResponse
        }
               
        do {
            //print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to UTF-8 string")")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print(error)
            throw UrlError.invalidData
        }
    }
    
    // MARK: - 주차장 정보를 가져오는 기능
    func getParkings(district: String, completion: @escaping ([Parking]?) -> Void) {
        let url = API.BASE_URL + district

        let alamo = AF.request(url, method: .get)
        alamo.validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let parkingInfo = try? JSONDecoder().decode(ParkingLot.self, from: json.rawData()) {
                    let parkingArray = parkingInfo.getParkingInfo.row
                    completion(parkingArray)
                } else {
                    print("Failed to decode JSON")
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    // MARK: - 좌표를 주소로 바꾸는 기능
    func getDistrict(long: Double, lat: Double, completion: @escaping (String?) -> Void) {
        let urlStr = API.ADDRESS_URL
        let param: Parameters = [
            "coords":"\(long),\(lat)",
            "output":"json"
        ]
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: API.NAVER_API_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API.NAVER_API_KEY)
        let headers = HTTPHeaders([header1,header2])

        let alamo = AF.request(urlStr, method: .get, parameters: param, headers: headers)
        alamo.validate().responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                let data = json["results"]
                let district = data[0]["region"]["area2"]["name"].string ?? ""
                completion(district)
                print("\(district)")
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
