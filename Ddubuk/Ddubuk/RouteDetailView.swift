////
////  RouteDetailView.swift
////  Ddubuk
////
////  Created by 김재완 on 2024/02/02.
////
//
//import SwiftUI
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//struct RouteDetailView: View {
//    var route: Route
//    @State var selectedRoute: Route? = nil
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
////                MapView(route: route)
////                    .frame(height: 100)
//                
//                if let imageUrlString = route.imageUrl, let imageUrl = URL(string: imageUrlString) {
//                    AsyncImage(url: imageUrl) { image in
//                        image.resizable()
//                    } placeholder: {
//                        ProgressView()
//                    }
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 100)
//                }
//            }
//            Spacer()
//            HStack {
//                Text("메모: \(route.memo)")
//                    .font(.headline)
//                
//                Text("소요 시간: \(route.duration)")
//                    .font(.headline)
//                
//                Text("이동 거리: \(route.distanceTraveled, specifier: "%.2f") 미터")
//                    .font(.headline)
//            }
//            HStack {
//                Text(route.title) // 'information' 대신 'title' 사용
//                List {
//                    ForEach(route.coordinates, id: \.self) { coordinate in
//                        // timestamp를 Date 타입으로 직접 참조
//                        Text("위도: \(coordinate.latitude), 경도: \(coordinate.longitude), 타임스탬프: \(coordinate.timestamp)")
//                    }
//                }
//            }
//            // 주소 정보를 표시하는 부분 추가
//            if let address = route.address {
//                Text("주소: \(address)")
//                    .padding(.top, 5)
//            }
//            // 타입 표시 추가
//            HStack{
//                ForEach(route.types, id: \.self) { type in
//                    Text(type.rawValue)
//                }
//            }
//        }
//        .padding()
//        .onAppear {
//            print("받아온 coordinates: \(self.route)")
//        }
//    }
//}
//
//
