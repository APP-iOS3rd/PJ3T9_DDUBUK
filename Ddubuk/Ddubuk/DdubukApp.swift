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
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    var viewModel = RecordViewModel()


    var body: some Scene {
        WindowGroup {
            let exampleRoute = Route(title: "예시", coordinates: [], imageUrl: nil, address: nil, memo: "", types: [], duration: "0", distanceTraveled: 0.0)
                       Main(route: exampleRoute) // Main 호출 시 route 전달
                           .environmentObject(viewModel) 
        }
    }
}
