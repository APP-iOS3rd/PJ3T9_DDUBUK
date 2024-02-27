//
//  ProfileView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//

import SwiftUI
import SDWebImageSwiftUI

enum ProfileSubView {
    case myRoutes
    case savedRoutes
}

class ProfileEnvironment: ObservableObject {
    @Published var isSearchDetailViewActive = false
}

struct ProfileView: View {
    @ObservedObject var routes = FireStoreManager.shared
    @EnvironmentObject var profileEnvironment: ProfileEnvironment
    @State private var selectedView: ProfileSubView = .myRoutes
    @State private var showingTrailView = false
    
    struct UserProfile {
        var username: String
        var walkStep: Int
        var walkCount: Int
        var imageURL: String
        var bookMark: Int
    }

    let dummyData1: UserProfile = UserProfile(
        username: "김키키",
        walkStep: 95,
        walkCount: 19,
        imageURL: "photo.fill",
        bookMark: 5
    )
    var body: some View {
            ScrollView(.vertical) {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: SettingView()) {
                                Image(systemName: "gearshape.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.primary)
                            }
                            .padding(.top, 40)
                        }
                        profileHeader(data: dummyData1)
                    }.background(LinearGradient(gradient: Gradient(colors: [Color("MainColor").opacity(0.5), Color.white]), startPoint: .top, endPoint: .center))
                    switch selectedView {
                    case .myRoutes:
                        ForEach(routes.routes) { route in
                            NavigationLink(destination: DetailTrailView(route: route)) {
                                SearchDetailView(searchRoute: route, showingTrailView: $showingTrailView)
                            }
                            .buttonStyle(PlainButtonStyle()) // 버튼 스타일 제거
                            .foregroundColor(.black) // 텍스트 색상 지정
                        }
                        .onTapGesture {
                            showingTrailView = true
                        }
                    case .savedRoutes:
                        ForEach(routes.routes) { route in
                            SearchDetailView(searchRoute: route, showingTrailView: $showingTrailView)
                        }.onTapGesture {
                            showingTrailView = true
                        }
                    case nil:
                        EmptyView()
                    }
                }
                .padding()
                
            }
            .ignoresSafeArea()
            .background(LinearGradient(gradient: Gradient(colors: [Color("MainColor").opacity(0.5), Color.white]), startPoint: .top, endPoint: .center))
        }
    
    
    private func profileHeader(data: UserProfile) -> some View {
        VStack {
            
            Image(systemName: data.imageURL)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 5)
                .padding(.bottom, 20)
                .padding()
            
            VStack(spacing: 10) {
                
                Text(data.username)
                    .padding(.top, -30)
                    .font(.custom("NotoSansKR-Medium", size: 24))
                HStack(spacing: 70){
                    VStack(spacing: 5) {
                        Text("\(data.walkStep)K")
                            .font(.custom("NotoSansKR-Bold", size: 24))
                            
                        
                        Text("총 걸음수")
                            .font(.custom("NotoSansKR-Medium", size: 16))
                    }
                    
                    VStack(spacing: 5) {
                        Text("\(data.walkCount)")
                            .font(.custom("NotoSansKR-Bold", size: 24))
                        
                        Text("산책수")
                            .font(.custom("NotoSansKR-Medium", size: 16))
                    }
                    
                    VStack(spacing: 5) {
                        Text("\(data.bookMark)")
                            .font(.custom("NotoSansKR-Bold", size: 24))
                        
                        Text("북마크")
                            .font(.custom("NotoSansKR-Medium", size: 16))
                    }
                }
                
                
            }
            
            Divider()
                .frame(height: 1)
                .background(.gray)
            
            HStack(spacing: 100) {
                VStack{
                    Button {
                        selectedView = .myRoutes
                    } label: {
                        Text("나의 산책로")
                            .foregroundColor(.black)
                            .fontWeight(selectedView == .myRoutes ? .bold : .regular)
                    }
                }

                VStack{
                    Button {
                        selectedView = .savedRoutes
                    } label: {
                        Text("저장한 산책로")
                            .foregroundColor(.black)
                            .fontWeight(selectedView == .savedRoutes ? .bold : .regular)
                    }
                    
                }
            }
            .padding(.top, 10)
            
            Divider()
                .frame(height: 1)
                .background(.gray)
        
        }
    }
}

#Preview {
    ProfileView()
}
