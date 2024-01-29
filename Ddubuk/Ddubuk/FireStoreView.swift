//
//  FireStoreView.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/22.
//

import SwiftUI
import Firebase

struct FireStoreView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var routes = FireStoreManager.shared
    @StateObject var locationManager = LocationManager()
    
    @State var address: String = ""
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var information: String = ""
    @State var currentLocation: String = "Not Available"
    @State var timerStart: Date = Date()
    @State var timerString: String = "00:00"
    @State var timer: Timer? = nil
    @State var elapsedTime: Int = 0
    @State var selectedRoute: Route? = nil

    //더미데이터
    let dummyRoute = Route(information: "Dummy Route", coordinates: [
        Coordinate(latitude: 37.5665, longitude: 126.9780, timestamp: Timestamp(date: Date().addingTimeInterval(-300))),
        Coordinate(latitude: 37.5675, longitude: 126.9790, timestamp: Timestamp(date: Date().addingTimeInterval(-200))),
        Coordinate(latitude: 37.5685, longitude: 126.9800, timestamp: Timestamp(date: Date().addingTimeInterval(-100)))
    ])

    var body: some View {
        ScrollView {
            NavigationView {
                VStack {
                   MapView(route: $selectedRoute)
            .frame(height: 300)
            .onAppear {
                // 뷰가 나타날 때 더미 데이터를 그립니다.
                self.selectedRoute = dummyRoute
            }
                    
                    Text("Timer: \(timerString)")
                        .padding()
                    
                    Button(action: {
                                            if self.timer == nil {
                                                self.locationManager.startTimer()
                                                self.locationManager.updateInformation(info: information)
                                                self.timerStart = Date().addingTimeInterval(TimeInterval(-self.elapsedTime))
                                                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                                                    let timeInterval = Int(Date().timeIntervalSince(self.timerStart))
                                                    let minutes = timeInterval / 60
                                                    let seconds = timeInterval % 60
                                                    self.timerString = String(format: "%02d:%02d", minutes, seconds)
                                                }
                                            }
                                        }) {
                                            Text("Start Tracking")
                                        }
                                        
                                        Button(action: {
                                            self.timer?.invalidate()
                                            self.timer = nil
                                            self.elapsedTime = Int(Date().timeIntervalSince(self.timerStart))
                                        }) {
                                            Text("Stop Tracking")
                                        }
                                        
                                        Button(action: {
                                            self.locationManager.stopTimer()
                                            self.timerString = "00:00"
                                            self.timerStart = Date()
                                            self.elapsedTime = 0
                                        }) {
                                            Text("Save")
                                        }
                                        .disabled(timer != nil)
                                        
                                        Button(action: {
                                            self.locationManager.resetData()
                                            self.timerString = "00:00"
                                            self.timerStart = Date()
                                            self.elapsedTime = 0
                                            self.information = ""
                                        }) {
                                            Text("Reset Data")
                                        }
                                        .disabled(timer != nil)
                                        
                                        TextField("Information", text: $information)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()
                                        
                                        Text("Current Location: \(currentLocation)")
                                            .padding()
                                        
                                        
                                        Button(action: {
                                            self.routes.fetchRoutes()
                                        }) {
                                            Text("Fetch Data")
                                        }
                    
                    List(routes.routes, id: \.information) { route in
            VStack(alignment: .leading) {
                Text(route.information)
                ForEach(route.coordinates, id: \.timestamp) { coordinate in
                    Text("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude), Timestamp: \(coordinate.timestamp.dateValue())")
                }
            }
            .onTapGesture {
                self.selectedRoute = route
            }
        }
                    .onAppear {
                        routes.fetchRoutes()
                    }
                    
                }
                .onReceive(locationManager.$currentLocation) { location in
                    self.currentLocation = "\(location.latitude), \(location.longitude)"
                }
                
            }
        }
    }
}


//#Preview {
//    FireStoreView()
//}
