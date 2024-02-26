//
//  FullView.swift
//  MapDemo
//
//  Created by 박호건 on 1/23/24.
//

import SwiftUI

struct FullView: View {
    
    @ObservedObject var routes = FireStoreManager.shared
    
    // Route 타입의 더미 데이터 생성
    let dummyRoute = Route(
        title: "길지만 이것은 바로 산책로 제목입니다.",
        coordinates: [Coordinate(latitude: 37.5665, longitude: 126.9780, timestamp: Date())],
        imageUrls: ["images-1", "images-2"],
        address: "어딘가의 주소",
        memo: "산책로 메모",
        types: [WalkingType.A],
        duration: 0,
        distanceTraveled: 823,
        recordedDate: Date(),
        stepsCount: 0
    )
    
//    var exploreViewRoutes: [String] = ["Route A", "Route B", "Route C"]
    
    var body: some View {
        ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 5), GridItem(.flexible(), spacing: 5)], spacing: 5) {
                    ForEach(routes.routes, id: \.self) { route in
                        ListingView(route: route, showEllipsis: true)
                            .frame(height: 300)
                }
                .padding()
                
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("MainColor").opacity(0.5), Color.white]), startPoint: .top, endPoint: .center))
        .navigationBarTitle("나의 산책로")
    }
}

#Preview {
    FullView()
}
