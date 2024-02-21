//
//  DetailTrailView.swift
//  Ddubuk
//
//  Created by 조민식 on 1/30/24.
//

import SwiftUI
import CoreLocation
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DetailTrailView: View {
    @Environment(\.dismiss) var dismiss
    var route: Route
    
    let trailDummy: TrailInfoDummy = TrailInfoDummy(trailPhoto: "trail1", trailName: "아차산에서 용마산으로", trailAddress: "서울특별시 광진구 용마산로 32길 2", rating: "4.32", trailLength: "8.3km", trailTime: "3시간 32분", profileImg: "user1", profileName: "몽식", trailNote: "밤에 꼭 한번 올라가보세요. 아차산에서 용마산으로 넘어가는 그 지점에서 보는 야경은 그 어느곳보다 아름답답니다! 산책로 난이도도 그렇게 어렵지 않아요~", trailTheme: "야경이 좋은 길", locations: [
        CLLocationCoordinate2D(latitude: 37.574955, longitude: 127.089379),
        CLLocationCoordinate2D(latitude: 37.574667, longitude: 127.089260),
        CLLocationCoordinate2D(latitude: 37.574072, longitude: 127.088965),
        CLLocationCoordinate2D(latitude: 37.573698, longitude: 127.088775),
        CLLocationCoordinate2D(latitude: 37.573203, longitude: 127.088884)
    ])
    
    var body: some View {
        ScrollView() {
            VStack {
                
                ZStack {
                    //산책로 대표사진
                    Image(trailDummy.trailPhoto)
                        .resizable()
                        .frame(height: 300)
                    VStack {
                        
                        HStack {
                            //뒤로 가기 버튼, 북마크 버튼
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.backward")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 30))
                                    .bold()
                                    .padding()
                            }
                            Spacer()
                            Image(systemName: "bookmark")
                                .foregroundStyle(.black)
                                .font(.system(size: 30))
                                .bold()
                                .padding()
                        }
                        Spacer()
                            .frame(height: 230)
                        
                    }
                }
                
                Divider()
                    .frame(minHeight: 3)
                    .overlay(Color.black)
                    .padding(-9)
                // Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        // 산책로 정보
                        Text(route.title)
                            .bold()
                            .font(.largeTitle)
                        
                        Text("주소 : \(route.address ?? "")")
                            .font(.system(size: 15))
                        Text("평점 : \(trailDummy.rating)")
                            .font(.system(size: 15))
                        Text("\(route.distanceTraveled, specifier: "%.2f")M  \(formatDuration(route.duration))")
                            .font(.system(size: 15))
                    }
                    .padding(.leading, 20)
                    VStack {
                        // 프로필
                        Image("user1")
                            .resizable()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 4)
                                    .shadow(radius: 4)
                            }
                            .padding(.trailing, 20)
                        Text(trailDummy.profileName)
                            .bold()
                    }
                }
                // 산책로 설명 박스
                HStack {
                    Text("이 산책로는..")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.leading, 15)
                
                    Spacer()
                }
                expandedView(text: route.memo)
                // 테마
                HStack {
                    ForEach(route.types, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .padding()
                // 경로 맵
                let coordinates = route.coordinates.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
                MapMakerView(coordinates)
                    .frame(height: 300)
                    .padding()
                Text("사진")
                    .fontWeight(.bold)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(route.imageUrls, id: \.self) { imageUrlString in
                            if let imageUrl = URL(string: imageUrlString) {
                                AsyncImage(url: imageUrl) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(height: 100)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 100) // 스크롤 뷰의 높이를 설정
                }
                HStack {
                    //리뷰
                    Text("리뷰")
                        .padding()
                    Spacer()
                }
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
    func formatDuration(_ duration: Int) -> String {
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        // 시간이 포함되어야 하는 경우 아래 형식 사용
        // return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return String(format: "%02d시간 %02분", hours, minutes)
    }
}


