//
//  BookMarkView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/29/24.
//

import SwiftUI

struct BookMarkView: View {
    var exploreViewRoutes: [String] = ["Route A", "Route B", "Route C"]

    var body: some View {
        ScrollView {
            VStack {
                // 제목
                VStack(alignment: .leading, spacing: 200) {
                    
                    Spacer().frame(height: 20)
                    
                    ForEach(exploreViewRoutes, id: \.self) { route in
                        ListingView(route: route, showEllipsis: true)
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
