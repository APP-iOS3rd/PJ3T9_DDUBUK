//
//  SearchDetailView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/25/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchDetailView: View {
    
    
//    @State private var starclicked: Bool = false
    
    var searchRoute: Route
    @Binding var showingTrailView: Bool
    
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
            if let firstImageUrl = searchRoute.imageUrls.first, let url = URL(string: firstImageUrl) {
                WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .frame(height: 150) // 너비에 맞춰 높이 조정
                    .background(Color(UIColor.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
      
                  
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .foregroundStyle(Color.gray)
                    .scaledToFit()
                    .padding()
                    .frame(width: 150, height: 110) // 너비에 맞춰 높이 조정
                    .background(Color(UIColor.systemGray5))
            }
                
            VStack(alignment:.leading){
                Text(searchRoute.title)
                    .font(.custom("NotoSansKR-Bold", size: 16))
                Text(searchRoute.address ?? "")
                    .font(.custom("NotoSansKR-Medium", size: 16))
            
                HStack(spacing: 7) {
                        // 거리 표시 방식 변경
                        Text(searchRoute.distanceTraveled >= 1000 ? String(format: "%.2fkm", searchRoute.distanceTraveled / 1000) : String(format: "%.0fm", searchRoute.distanceTraveled))
                            .font(.custom("NotoSansKR-Bold", size: 11))
                        Text(formatDuration(searchRoute.duration))
                            .font(.custom("NotoSansKR-Bold", size: 11))
                        Text("\(searchRoute.stepsCount)걸음")
                            .font(.custom("NotoSansKR-Bold", size: 11))
                    }
                }
        }
        .padding()
        .fullScreenCover(isPresented: $showingTrailView) {
            DetailTrailView(route: searchRoute)
        }
    }
    func formatDuration(_ duration: Int) -> String {
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        if duration < 60 {
            return String(format: "%02d초", seconds)
        } else if duration < 3600 {
            return String(format: "%2d분 %02d초", minutes, seconds)
        } else {
            return String(format: "%2d시 %02d분", hours, minutes)
        }
    }
}

//#Preview {
//    SearchDetailView()
//}
