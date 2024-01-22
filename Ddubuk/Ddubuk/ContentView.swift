//
//  ContentView.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/17.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            MapView()
                .tabItem { Image(systemName: "map") }
        }
    }

   
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
