//
//  Main.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//


import SwiftUI

struct Main: View {
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

            NavigationView {
                CommunityView()
                    .navigationBarTitle("커뮤니티")
            }
            .tabItem {
                Image(systemName: "person.3")
                Text("커뮤니티")
            }

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
        }
    }
}

#Preview {
    Main()
}
