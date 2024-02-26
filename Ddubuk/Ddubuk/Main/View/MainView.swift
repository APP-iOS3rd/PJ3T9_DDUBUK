//
//  Main.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//


import SwiftUI

struct Main: View {
    
    var route: Route
    @EnvironmentObject var viewModel: RecordViewModel
    @State private var showingRecordView = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass.circle.fill")
                Text("검색")
            }
            .tag(0)
            Text("로딩중...")
                       .tabItem {
                           Image(systemName: "figure.walk.circle.fill")
                           Text("기록")
                           
                       }
//                       .onAppear {
//                           showingRecordView = true
//                       }
                       .fullScreenCover(isPresented: $showingRecordView) {
                           RecordView(selectedTab: $selectedTab).environmentObject(viewModel)
                       }
                       .tag(1)
            
            NavigationView {
                MapView()
            }
            .tabItem {
                Image(systemName: "map.fill")
                Text("지도")
            }
            .tag(2)
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("프로필")
            }
            .tag(3)
        }.background(Color.white)
            .onChange(of: selectedTab) {
                if selectedTab == 1 {
                    showingRecordView = true
                }
            }
    }
}

//#Preview {
//    Main()
//}



//let exampleRoute = Route(title: "예시", coordinates: [], imageUrl: nil, address: nil, memo: "", types: [], duration: "0", distanceTraveled: 0.0)
//            Main(route: exampleRoute) // Main 호출 시 route 전달
//                .environmentObject(viewModel)
