//
//  SearchDetailView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/25/24.
//

import SwiftUI

struct SearchDetailView: View {
    
//    @State private var starclicked: Bool = false
    
    struct Data {
        var Title: String
        var Description: String
        var Star: String
        var Distance: String
        var EstimatedTime: Int
        
    }

    let dummyData2: Data = Data(
        Title: "망원동 밤에 걷기 좋은 산책로",
        Description: "서울시 망원동",
        Star: "4.2",
        Distance: "2.9",
        EstimatedTime: 40
    )
    
    var body: some View {
        HStack {
            
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .frame(width: 150,height: 150)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
                
//                Button {
//                    starclicked.toggle()
//                } label: {
//                    Image(systemName: starclicked ? "star.fill" : "star")
//                            .foregroundColor(.yellow )
//                            .padding()
//                }

            }
            VStack(alignment:.leading){
            Text(dummyData2.Title)
                .fontWeight(.bold)
            Text(dummyData2.Description)
            
                HStack(spacing: 6) {
                    Text("\(dummyData2.Distance)km")
                    Text("\(dummyData2.EstimatedTime)분")
                    Image(systemName: "star.fill")
                    Text(dummyData2.Star)
                }
            }
            .padding(.top, -70)
        }
        .padding()
    }
}

#Preview {
    SearchDetailView()
}
