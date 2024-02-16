//
//  ProfileView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @ObservedObject var routes = FireStoreManager.shared
    
    // 더미 데이터 모델
    struct UserProfile {
        var username: String
        var bio: String
        var walkCount: Int
        var imageURL: String
        var walkRoutes: [String]
        var instagramID: String
    }
    
    // 더미 데이터
    let dummyData1: UserProfile = UserProfile(
        username: "H.Methew",
        bio: "안녕하세요 산책을 좋아하는 20대 남성입니다.",
        walkCount: 11,
        imageURL: "photo.fill",
        walkRoutes: ["Route A", "Route B", "Route C"],
        instagramID: "sisi"
    )
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack {
                profileHeader(data: dummyData1)
            }
            .padding()
        }
        .navigationBarTitle("프로필")
        .navigationBarItems(trailing: NavigationLink(destination: SettingView()) {
            Image(systemName: "gearshape.fill")
                .imageScale(.large)
                .foregroundColor(.primary)
        })
        
    }
    
    private func profileHeader(data: UserProfile) -> some View {
        VStack {
            
            Image(systemName: data.imageURL)
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 5)
                .padding(.bottom, 20)
                .padding()
            
            VStack {
                
                Text(data.username)
                    .padding(.top, -30)
                    .fontWeight(.bold)
                
                
                Text("산책수")
                    .fontWeight(.bold)
                Text("\(data.walkCount)")
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 10) {
                HStack(spacing: 190) {
                    Text("나의 산책로")
                    NavigationLink(destination: FullView()) {
                        Text("전체보기")
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) { // 간격을 20으로 조정
                        ForEach(routes.routes, id: \.self) { route in
                            VStack(alignment: .center) {
                                ListingView(route: route, showEllipsis: false)
                                    .frame(width: 250, height: 350)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal, 15) // 좌우 패딩을 15로 조정
                    .accentColor(.primary)
                    .onAppear {
                        routes.fetchRoutes()
                    }
                }
                
                Divider()
                    .frame(height: 3)
                    .background(.black)
                
                VStack(spacing: 10) {
                    HStack(spacing: 190) {
                        Text("저장목록")
                        NavigationLink(destination: BookMarkView()) {
                            Text("전체보기")
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 20) { // 간격을 20으로 조정
                            ForEach(routes.routes, id: \.self) { route in
                                VStack(alignment: .center) {
                                    ListingView(route: route, showEllipsis: false)
                                        .frame(width: 250, height: 350)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding(.horizontal, 15) // 좌우 패딩을 15로 조정
                        .accentColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
