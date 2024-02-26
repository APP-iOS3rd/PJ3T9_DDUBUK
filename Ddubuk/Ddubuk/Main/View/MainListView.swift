//
//  MainListView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/1/24.
//

import SwiftUI

struct MainListView: View {
    
//    @State private var starclicked: Bool = false
    
    struct Data {
        var Title: String
        var Description: String
    }

    let dummyData2: Data = Data(
        Title: "중랑천을 따라 걷는 강아지 코스",
        Description: "서울특별시 광진구"

    )
    
    var body: some View {
        VStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 200,height: 200)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
            Text(dummyData2.Title)
                .font(.custom("NotoSansKR-Bold", size: 16))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            Text(dummyData2.Description)
                .font(.custom("NotoSansKR-Medium", size: 16))
        }
        .padding()
    }
}

#Preview {
    MainListView()
}
