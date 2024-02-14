//
//  BookMarkView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/29/24.
//

import SwiftUI

struct BookMarkView: View {

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
                VStack(alignment: .leading, spacing: 200) {
                    
                    Spacer().frame(height: 20)
                    
                    // 여기에 ExploreView에서 사용한 더미 데이터로 구성된 리스트 표시 코드 추가
                    ForEach(exploreViewRoutes, id: \.self) { route in
                        ListingView(route: dummyRoute, showEllipsis: true)
                            .frame(height: 300)
                            .padding(.bottom, 10)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("저장목록")
    }
}

#Preview {
    BookMarkView()
}
