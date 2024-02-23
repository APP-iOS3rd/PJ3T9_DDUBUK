//
//  DdubukApp.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/17.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct DdubukApp: App {
    
    
    init() {
            FirebaseApp.configure()
        }
    
    var viewModel = RecordViewModel()


    var body: some Scene {
        WindowGroup {
            let exampleRoute = Route(
                title: "예시",
                coordinates: [],
                imageUrls: [],
                address: nil,
                memo: "",
                types: [],
                duration: 0,
                distanceTraveled: 0.0,
                recordedDate: Date(),
                stepsCount: 0
                )
                       Main(route: exampleRoute) // Main 호출 시 route 전달
                           .environmentObject(viewModel)
        }
    }
}
