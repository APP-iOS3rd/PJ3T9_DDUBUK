//
//  ListingView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct ListingView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @StateObject var locationManager = LocationManager()
    @State var currentLocationDescription: String = "Not Available"
    @ObservedObject var routes = FireStoreManager.shared
    @State private var showActionSheet = false
    
    var route: Route
    
    var showEllipsis: Bool = true
    
    let sampleRoute = Route(
        title: "아름다운 산책로",
        coordinates: [Coordinate(latitude: 37.5665, longitude: 126.9780, timestamp: Date())], // 예시 좌표
        imageUrls: ["images-1", "images-2"], // 프리뷰에서 사용할 이미지 이름 또는 URL
        address: "서울특별시 중구",
        memo: "맑은 날 산책하기 좋음",
        types: [WalkingType.A], // WalkingType에 따라 변경
        duration: 30,
        distanceTraveled: 1.5,
        recordedDate: Date(),
        stepsCount: 0
    )
    var body: some View {
        
        GeometryReader { geometry in
            HStack(spacing: 10) {
                NavigationLink(destination: DetailTrailView(route: route)) {
                    VStack(alignment: .leading) {
                        if let firstImageUrl = route.imageUrls.first, let url = URL(string: firstImageUrl) {
                                WebImage(url: url)
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .scaledToFit()
                                .padding(5)
//                                .frame(width: geometry.size.width, height: geometry.size.width * 0.6) // 너비에 맞춰 높이 조정
                                .background(Color(UIColor.systemGray5))
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .foregroundStyle(Color.gray)
                                .scaledToFit()
                                .padding()
//                                .frame(width: geometry.size.width, height: geometry.size.width * 0.6) // 너비에 맞춰 높이 조정
                                .background(Color(UIColor.systemGray5))
                        }
                        
                        // 텍스트 정보를 담는 VStack
                        Text(route.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                        Text(route.memo)
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
//                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                    }
                }
                HStack {
                    VStack {
                        Text("코스 길이")
                        Text(route.distanceTraveled >= 1000 ? String(format: "%.2f KM", route.distanceTraveled / 1000) : String(format: "%.0f M", route.distanceTraveled))
                        
                    }
                    Divider().frame(height: 50)
                        .foregroundStyle(Color.black)
                    VStack {
                        Text("걸은 시간")
                        Text("\(route.duration / 60)분 \(route.duration % 60)초")
                    }
                    Divider().frame(height: 50)
                    VStack {
                        Text("걸음 수")
                        Text("99,999")
                    }
                }
//                .frame(maxWidth: .infinity) // HStack을 화면 너비에 맞게 확장
                .font(.subheadline)
            }
            .background(RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
            )
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1))
            .padding()
        }
//        .padding(.leading, -199)
    }
}
    #Preview {
        ListingView(route:  Route(
            title: "아름다운 산책로",
            coordinates: [Coordinate(latitude: 37.5665, longitude: 126.9780, timestamp: Date())], // 예시 좌표
            imageUrls: ["images-1", "images-2"], // 프리뷰에서 사용할 이미지 이름 또는 URL
            address: "서울특별시 중구",
            memo: "맑은 날 산책하기 좋음",
            types: [WalkingType.A], // WalkingType에 따라 변경
            duration: 0,
            distanceTraveled: 1.5,
            recordedDate: Date(),
            stepsCount: 0
        ), showEllipsis: false) // ExploreView에서는 ellipsis 표시
    }

