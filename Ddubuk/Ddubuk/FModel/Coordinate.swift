//
//  Coordinate.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

import Foundation

struct Coordinate: Codable, Hashable {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, timestamp
    }
}
