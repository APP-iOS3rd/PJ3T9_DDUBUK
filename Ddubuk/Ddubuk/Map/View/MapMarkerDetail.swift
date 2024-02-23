//
//  MapMarkerDetail.swift
//  Ddubuk
//
//  Created by 조민식 on 2/16/24.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct MapMarkerDetail: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var seletedResult: Route
    
    var body: some View {
        VStack {
            NavigationLink(destination: DetailTrailView(route: seletedResult))
            {
                HStack {
                    if let firstImageUrl = seletedResult.imageUrls.first, let url = URL(string: firstImageUrl) {
                            WebImage(url: url)
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFit()
                            .padding(5)
                            .frame(width: 150) // 너비에 맞춰 높이 조정
                            .background(Color(UIColor.systemGray5))
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .foregroundStyle(Color.gray)
                            .scaledToFit()
                            .padding()
                            .frame(width: 150, height: 110) // 너비에 맞춰 높이 조정
                            .background(Color(UIColor.systemGray5))
                    }

                                    
                    VStack {
                        Text(seletedResult.title)
                            .font(.custom("NotoSansKR-Bold", size: 16))
                            .foregroundStyle(Color.black)
                        
                        Text(seletedResult.address ?? "")
                            .font(.custom("NotoSansKR-Medium", size: 13))
                            .foregroundStyle(Color.black)
                            .opacity(0.5)
                        HStack {
                            Text("\(seletedResult.distanceTraveled, specifier: "%.2f")M")
                                .font(.custom("NotoSansKR-Medium", size: 13))
                                .foregroundStyle(Color.black)
                                .opacity(0.5)
                            Text(formatDuration(seletedResult.duration))
                                .font(.custom("NotoSansKR-Medium", size: 13))
                                .foregroundStyle(Color.black)
                                .opacity(0.5)
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
    func formatDuration(_ duration: Int) -> String {
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        // 시간이 포함되어야 하는 경우 아래 형식 사용
        // return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return String(format: "%02d분 %02d초", minutes, seconds)
    }
}

