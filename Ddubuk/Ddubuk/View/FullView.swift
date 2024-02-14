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
        recordedDate: Date() // 현재 날짜와 시간
    )

    var exploreViewRoutes: [String] = ["Route A", "Route B", "Route C"] // ExploreView에서 사용한 더미 데이터


    var body: some View {
        ScrollView {
            VStack {
                // 제목
                VStack(spacing: 20) {

                    Spacer()

                    ForEach(routes.routes, id: \.self) { route in
                        ListingView(route: route, showEllipsis: true)
                            .frame(height: 300)
                            .padding(.bottom, 30)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("나의 산책로")
        .padding(20)
    }
}

#Preview {
    FullView()
}
