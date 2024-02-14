//
//  CommunityView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/29/24.
//

import SwiftUI
import Firebase

struct CommunityView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var routes = FireStoreManager.shared
    @StateObject var locationManager = LocationManager()
    
    @State var currentLocationDescription: String = "Not Available"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Text("현재위치: \(currentLocationDescription)")
                        .padding()
                    
                    Button(action: {
                        self.routes.fetchRoutes()
                    }) {
                        Text("새로고침")
                    }
                    
                    List(routes.routes, id: \.self) { route in
                        NavigationLink(destination: CommunityDetailView(route: route)) {
                            Text(route.title)
                        }
                    }
                    .frame(height: 300)
                    .onAppear {
                        routes.fetchRoutes()
                    }
                }
                .onReceive(locationManager.$currentLocation) { location in
                    if let location = location {
                        self.currentLocationDescription = "위도: \(location.latitude), 경도: \(location.longitude)"
                    } else {
                        self.currentLocationDescription = "위치 정보 없음"
                    }
                }
            }
        }
    }
}



//#Preview {
//    CommunityView()
//}
