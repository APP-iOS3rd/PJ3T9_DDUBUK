//
//  Main.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//


import SwiftUI
import MapKit

struct Main: View {
    var route: Route
    @EnvironmentObject var viewModel: RecordViewModel
    

    
    var body: some View {
        TabView {
            NavigationView {
                SearchView()
                    .navigationBarTitle("검색")
            }
            .tabItem {
                Image(systemName: "magnifyingglass.circle.fill")
                Text("검색")
            }

//            NavigationView {
//                StopwatchView()
//                    .navigationBarTitle("커뮤니티")
//            }
//            .tabItem {
//                Image(systemName: "person.3")
//                Text("커뮤니티")
//            }

            NavigationView {
                RecordView()
                    .navigationBarTitle("기록")
            }
            .tabItem {
                Image(systemName: "figure.walk.circle.fill")
                Text("기록")
            }

            NavigationView {
                MapView()
                    .navigationBarTitle("지도")
            }
            .tabItem {
                Image(systemName: "map.fill")
                Text("지도")
            }
        
            NavigationView {
                ProfileView()
                    .navigationBarTitle("프로필")
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("프로필")
            }
        }.background(Color.white)
    }
}

//#Preview {
//    Main()
//}



//let exampleRoute = Route(title: "예시", coordinates: [], imageUrl: nil, address: nil, memo: "", types: [], duration: "0", distanceTraveled: 0.0)
//            Main(route: exampleRoute) // Main 호출 시 route 전달
//                .environmentObject(viewModel)
