//
//  FullView.swift
//  MapDemo
//
//  Created by 박호건 on 1/23/24.
//

import SwiftUI

struct FullView: View {
    var exploreViewRoutes: [String] = ["Route A", "Route B", "Route C"]
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
