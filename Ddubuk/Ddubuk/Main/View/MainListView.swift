//
//  MainListView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/1/24.
//

import SwiftUI

struct MainListView: View {
    
    @State private var starclicked: Bool = false
    
    struct Data {
        var Title: String
        var Description: String
        var Star: String
        var Distance: String
        
    }

    let dummyData2: Data = Data(
        Title: "중랑천을 따라 걷는 강아지 코스",
        Description: "서울특별시 광진구 능동로 261",
        Star: "4.2",
        Distance: "2.9km"
    )
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Best 강아지와 산책코스")
                .fontWeight(.bold)
            
            
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .frame(height: 200)
                    .foregroundColor(.gray)
                
                Button {
                    starclicked.toggle()
                } label: {
                    Image(systemName: starclicked ? "star.fill" : "star")
                                            .foregroundColor(.yellow )
                                            .padding()
                }

            }
            Text(dummyData2.Title)
                .fontWeight(.bold)
            Text(dummyData2.Description)
            
            HStack {
                Text(dummyData2.Star)
                Text(dummyData2.Distance)
            }
        }
        .padding()
    }
}

#Preview {
    MainListView()
}
