//
//  Route.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

import Foundation

struct Route: Codable, Hashable, Identifiable {
    let id = UUID()
    var title: String
    var coordinates: [Coordinate]
    var imageUrls: [String]
    var address: String?
    var memo: String
    var types: [WalkingType]
    var duration:  Int
    var distanceTraveled: Double
    var recordedDate: Date
    var stepsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case title, coordinates, imageUrls, address, memo, types, duration, distanceTraveled, recordedDate, stepsCount
    }
    
}
