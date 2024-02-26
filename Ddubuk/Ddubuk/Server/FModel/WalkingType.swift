//
//  WalkingType.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

import Foundation

enum WalkingType: String, Codable, CaseIterable {
    case NightView = "야경이 좋은"
    case Day = "낮에 걷기 좋은"
    case Dog = "강아지와 함께"
    case Child = "아이와 함께"
    case Trees = "나무가 많은"
    case Water = "물을 따라 걷는"
    case Hill = "언덕을 오르는"
    case Alley = "골목길을 걷는"
    // 타입 추가 가능
}
