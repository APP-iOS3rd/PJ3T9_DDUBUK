//
//  Item.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/17.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
