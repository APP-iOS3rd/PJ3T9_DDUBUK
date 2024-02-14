//
//  CommunityDetailView.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/05.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CommunityDetailView: View {
    var route: Route
    
    var recordedDate: Date = Date()
    
    @EnvironmentObject var viewModel: RecordViewModel
    @State var selectedRoute: Route? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                RecordMap(userLocations: viewModel.userLocations,
                          isRecording:viewModel.isRecording,
                          timerState: viewModel.timerState
                )
                .frame(height: 330)
                Divider()
                    .frame(minHeight: 3)
                    .overlay(Color.black)
                    .padding(-9)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    
                    HStack{
                        Text("날짜:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(formatDate(recordedDate))
                    }
                    
                    HStack {
                        Text("주소:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(route.address ?? "주소 위치확인불가")")
                    }
                    
                    
                    HStack{
                        Text("제목:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(route.title)")
                        
                        
                    }
                    HStack{
                        Text("설명:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(route.memo)")
                    }
                    
                    
                    HStack(alignment: .center, spacing: 30) {
                        Spacer()
                        VStack {
                            Text("산책거리")
                                .fontWeight(.bold)
                            Text("\(route.distanceTraveled, specifier: "%.2f")M")
                        }
                        
                        VStack {
                            Text("걸음수-더미")
                                .fontWeight(.bold)
                            Text("10,000")
                        }
                        
                        VStack {
                            Text("총 시간")
                                .fontWeight(.bold)
                            //                            Text("\(dummyData.totalTime)")
                            //                                .fontWeight(.bold)
                            Text(formatDuration(route.duration))
                        }
                        Spacer()
                    }
                    
                    // 타입 표시 추가
                    
                    Text("테마")
                        .fontWeight(.bold)
                    HStack{
                            ForEach(route.types, id: \.self) { type in
                                Text(type.rawValue)
                            }
                    }
                }
                
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
            }
            .padding()
            .onAppear {
                print("받아온 coordinates: \(self.route)")
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        formatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 날짜 형식
        return formatter.string(from: date)
    }
    
    func formatDuration(_ duration: Int) -> String {
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        // 시간이 포함되어야 하는 경우 아래 형식 사용
        // return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


//#Preview {
//    CommunityDetailView()
//}
