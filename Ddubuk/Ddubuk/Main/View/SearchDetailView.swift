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
            Rectangle()
                .frame(width: 150,height: 150)
                .cornerRadius(10)
                .foregroundColor(.gray)
                
            VStack(alignment:.leading){
            Text(dummyData2.Title)
                    .font(.custom("NotoSansKR-Bold", size: 16))
            Text(dummyData2.Description)
                    .font(.custom("NotoSansKR-Medium", size: 16))
            
                HStack(spacing: 6) {
                    Text("\(dummyData2.Distance)km")
                        .font(.custom("NotoSansKR-Bold", size: 16))
                    Text("\(dummyData2.EstimatedTime)분")
                        .font(.custom("NotoSansKR-Bold", size: 16))
                    Image(systemName: "star.fill")
                    Text(dummyData2.Star)
                        .font(.custom("NotoSansKR-Bold", size: 16))
                }
            }
            .padding(.top, -60)
        }
        .padding()
    }
}

#Preview {
    SearchDetailView()
}
