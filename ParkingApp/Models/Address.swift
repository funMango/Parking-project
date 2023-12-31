// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let address = try? JSONDecoder().decode(Address.self, from: jsonData)

import Foundation

// MARK: - Address
struct Address: Codable {
    let status: Status
    let results: [Results]
}

// MARK: - Result
struct Results: Codable {
    let name: String
    let code: Code
    let region: Region
    let land: Land
}

// MARK: - Code
struct Code: Codable {
    let id, type, mappingID: String

    enum CodingKeys: String, CodingKey {
        case id, type, mappingID
    }
}

// MARK: - Land
struct Land: Codable {
    let type, number1, number2: String
    let addition0, addition1, addition2, addition3: Addition
    let addition4: Addition
    let coords: Coords
}

// MARK: - Addition
struct Addition: Codable {
    let type, value: String
}

// MARK: - Coords
struct Coords: Codable {
    let center: Center
}

// MARK: - Center
struct Center: Codable {
    let crs: CRS?
    let x, y: Double
}

enum CRS: String, Codable {
    case empty, epsg4326
}

// MARK: - Region
struct Region: Codable {
    let area0: Area
    let area1: Area1
    let area2, area3, area4: Area
}

// MARK: - Area
struct Area: Codable {
    let name: String
    let coords: Coords
}

// MARK: - Area1
struct Area1: Codable {
    let name: String
    let coords: Coords
    let alias: String
}

// MARK: - Status
struct Status: Codable {
    let code: Int
    let name, message: String
}
