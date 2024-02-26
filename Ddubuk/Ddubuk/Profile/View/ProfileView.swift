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
    @State private var selectedView: ProfileSubView? = nil
    
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
                    profileHeader(data: dummyData1)
                    switch selectedView {
                    case .myRoutes:
                        SearchDetailView()
                    case .savedRoutes:
                        BookMarkView()
                    case nil:
                        EmptyView()
                    }
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color("MainColor").opacity(0.5), Color.white]), startPoint: .top, endPoint: .center))
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
                HStack(spacing: 90){
                    VStack {
                        Text("\(data.walkStep)K")
                            .fontWeight(.bold)
                        
                        Text("총 걸음수")
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        Text("\(data.walkCount)")
                            .fontWeight(.bold)
                        
                        Text("산책수")
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        Text("\(data.bookMark)")
                            .fontWeight(.bold)
                        
                        Text("북마크")
                            .fontWeight(.bold)
                    }
                }
                
                
            }
            
            Divider()
                .frame(height: 3)
                .background(.black)
            
            HStack(spacing: 150) {
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
                .frame(height: 3)
                .background(.black)
        
        }
    }
}

#Preview {
    ProfileView()
}
