//
//  ProfileView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//

import SwiftUI

struct ProfileView: View {
    // 더미 데이터 모델
    struct UserProfile {
        var username: String
        var bio: String
        var walkCount: Int
        var followers: Int
        var following: Int
        var imageURL: String
        var walkRoutes: [String]
        var instagramID: String
    }

    // 더미 데이터
    let dummyData1: UserProfile = UserProfile(
        username: "H.Methew",
        bio: "안녕하세요 산책을 좋아하는 20대 남성입니다.",
        walkCount: 11,
        followers: 50,
        following: 124,
        imageURL: "photo.fill", // 여기에 실제 이미지 URL을 넣어야 합니다.
        walkRoutes: ["Route A", "Route B", "Route C"],
        instagramID: "sisi"
    )

    var body: some View {
        NavigationView {
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
    }

    private func profileHeader(data: UserProfile) -> some View {
        VStack {
            HStack {
                Image(systemName: data.imageURL)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 5)
                    .padding(.bottom, 20)
                    .padding()

                Spacer()

                VStack {
                    Text("산책수")
                        .fontWeight(.bold)
                    Text("\(data.walkCount)")
                        .fontWeight(.bold)
                }

                VStack {
                    Text("팔로워")
                        .fontWeight(.bold)
                    Text("\(data.followers)")
                        .fontWeight(.bold)
                }

                VStack {
                    Text("팔로잉")
                        .fontWeight(.bold)
                    Text("\(data.following)")
                        .fontWeight(.bold)
                }
                .padding()
                Spacer()
            }

            HStack {
                Text(data.username)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                VStack(alignment: .leading) {
                    Text(data.bio)
                    Text(data.instagramID)
                }
                .padding()
            }
            Spacer()

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
                    LazyHStack(spacing: 10) {
                        ForEach(data.walkRoutes, id: \.self) { route in
                            ListingView(route: route, showEllipsis: false)
                                .frame(width: 300, height: 520)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
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
                    LazyHStack(spacing: 10) {
                        ForEach(data.walkRoutes, id: \.self) { route in
                            ListingView(route: "route", showEllipsis: false)
                                .frame(width: 300, height: 520)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
