//
//  DetailTrailView.swift
//  Ddubuk
//
//  Created by 조민식 on 1/30/24.
//

import SwiftUI
import CoreLocation
import MapKit
import CoreLocation

struct DetailTrailView: View {
    
    
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
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.black)
                                .font(.system(size: 30))
                                .bold()
                                .padding()
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
                // Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        // 산책로 정보
                        Text(trailDummy.trailName)
                            .bold()
                            .font(.largeTitle)
                        
                        Text("주소 : \(trailDummy.trailAddress)")
                            .font(.system(size: 15))
                        Text("평점 : \(trailDummy.rating)")
                            .font(.system(size: 15))
                        Text("\(trailDummy.trailLength)  \(trailDummy.trailTime)")
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
                expandedView(sampleText: trailDummy.trailNote)
                    .padding()
                // 테마
                HStack {
                    Text(trailDummy.trailTheme)
                        .padding()
                    Spacer()
                }
                // 경로 맵
                MapMakerView(trailDummy.locations)
                    .frame(height: 300)
                    .padding()
                HStack {
                    //리뷰
                    Text("리뷰")
                        .padding()
                    Spacer()
                }
                
            }
        }
    }
}

#Preview {
    DetailTrailView()
}
