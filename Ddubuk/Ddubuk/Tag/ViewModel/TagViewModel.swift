//
//  TagViewModel.swift
//  Ddubuk
//
//  Created by 조민식 on 2/2/24.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var isSelected: Bool = false
}
