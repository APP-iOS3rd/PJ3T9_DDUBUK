//
//  FullView.swift
//  MapDemo
//
//  Created by 박호건 on 1/23/24.
//

import SwiftUI

struct FullView: View {
    // 더미 데이터
    struct WalkRoute {
        var title: String
        var date: String
        var length: String
        var duration: String
        var steps: String
        var images: [String]
    }

    let dummyData: WalkRoute = WalkRoute(
        title: "길지만 이것은 바로 산책로 제목입니다.",
        date: "2024년 2월 12일",
        length: "823m",
        duration: "23분",
        steps: "5920걸음",
        images: ["images-1", "images-2", "images-3", "images-4"]
    )


    var exploreViewRoutes: [String] = ["Route A", "Route B", "Route C"] // ExploreView에서 사용한 더미 데이터


    var body: some View {
        ScrollView {
            VStack {
                // 제목
                VStack(alignment: .leading, spacing: 200) {

                    Spacer()

                    ForEach(exploreViewRoutes, id: \.self) { route in
                        ListingView(route: route, showEllipsis: true)
                            .frame(height: 300)
                            .padding(.bottom, 10)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("나의 산책로")
    }
}

#Preview {
    FullView()
}
