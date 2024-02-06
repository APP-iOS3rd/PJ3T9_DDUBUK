//
//  Route.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

import Foundation

struct Route: Codable, Hashable {
    var title: String
    var coordinates: [Coordinate]
    var imageUrl: String?
    var address: String?
    var memo: String
    var types: [WalkingType]
    var duration:  String
    var distanceTraveled: Double
    
    enum CodingKeys: String, CodingKey {
        case title, coordinates, imageUrl, address, memo, types, duration, distanceTraveled
    }
}
