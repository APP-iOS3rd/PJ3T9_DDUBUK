////
////  FireStoreView.swift
////  Ddubuk
////
////  Created by 김재완 on 2024/02/02.
////
//
//import SwiftUI
//
//import SwiftUI
//import Firebase
//
//struct FireStoreView: View {
//    
//    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
//    @EnvironmentObject var viewModel: RecordViewModel
//    
//    @ObservedObject var routes = FireStoreManager.shared
//    @StateObject var locationManager = LocationManager()
//    
//    @State var address: String = ""
//    @State var latitude: String = ""
//    @State var longitude: String = ""
//    @State var currentLocationDescription: String = "Not Available"
//    @State var timerStart: Date = Date()
//    @State var timerString: String = "00:00"
//    @State var timer: Timer? = nil
//    @State var elapsedTime: Int = 0
//    @State var selectedRoute: Route? = nil
//    @State private var isRecordCompleteViewPresented = false
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack {
//                    RecordMap(userLocations: viewModel.userLocations, isRecording: viewModel.isRecording, timerState: viewModel.timerState)
//                        .frame(height: 300)
//                    HStack{
//                        Text("이동 시간: \(timerString)")
//                            .padding()
//                        Spacer()
//                        Text("이동 거리: \(locationManager.distanceTraveled, specifier: "%.2f") 미터")
//                            .padding()
//                    }
//                    Button(action: {
//                        if self.timer == nil {
//                            
//                            self.locationManager.startTimer()
//                            self.timerStart = Date().addingTimeInterval(TimeInterval(-self.elapsedTime))
//                            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//                                let timeInterval = Int(Date().timeIntervalSince(self.timerStart))
//                                let minutes = timeInterval / 60
//                                let seconds = timeInterval % 60
//                                self.timerString = String(format: "%02d:%02d", minutes, seconds)
//                            }
//                        }
//                    }) {
//                        Text("산책하기")
//                    }
//                    
//                    Button(action: {
//                        
//                        self.timer?.invalidate()
//                        self.timer = nil
//                        self.elapsedTime = Int(Date().timeIntervalSince(self.timerStart))
//                    }) {
//                        Text("산책정지")
//                    }
//                    
//                    Button(action: {
//                        self.locationManager.stopTimer() // 타이머 중지 및 durationString 계산
//                        self.timer?.invalidate() // 타이머를 무효화합니다.
//                        self.timer = nil // 타이머를 nil로 설정하여 초기화합니다.
//                        self.timerString = "00:00" // 타이머 문자열을 초기화합니다.
//                        self.elapsedTime = 0 // 경과 시간을 0으로 초기화합니다.
//                        self.locationManager.tempCoordinates = self.locationManager.coordinates
//                        self.locationManager.tempDurationString = self.locationManager.durationString
//                        // 디버깅 출력
//                        print("Save button clicked")
//                        print("Coordinates saved: \(self.locationManager.tempCoordinates.count)")
//                        print("Duration saved: \(self.locationManager.tempDurationString)")
//                        print("Distance saved: \(self.locationManager.tempDistanceTraveled)")
//
//                        self.isRecordCompleteViewPresented = true // RecordCompleteView를 표시합니다.
//                    }) {
//                        Text("저장")
//                    }
//                    .disabled(timer != nil)
//                    .sheet(isPresented: $isRecordCompleteViewPresented) {
//                        RecordCompleteView(locationManager: locationManager)
//                    }
//                    
//                    Button(action: {
//                        self.locationManager.resetData()
//                        self.timerString = "00:00"
//                        self.timerStart = Date()
//                        self.elapsedTime = 0
//                    }) {
//                        Text("초기화")
//                    }
//                    .disabled(timer != nil)
//                    
//                    Text("현재위치: \(currentLocationDescription)")
//                        .padding()
//                    
//                    Button(action: {
//                        self.routes.fetchRoutes()
//                    }) {
//                        Text("새로고침")
//                    }
//                    
//                    List(routes.routes, id: \.self) { route in
//                        NavigationLink(destination: RouteDetailView(route: route)) {
//                            Text(route.title)
//                        }
//                    }
//                    .frame(height: 300)
//                    .onAppear {
//                        routes.fetchRoutes()
//                    }
//                }
//                .onReceive(locationManager.$currentLocation) { location in
//                    if let location = location {
//                        self.currentLocationDescription = "위도: \(location.latitude), 경도: \(location.longitude)"
//                    } else {
//                        self.currentLocationDescription = "위치 정보 없음"
//                    }
//                }
//            }
//        }
//    }
//}
//
//
////#Preview {
////    FireStoreView()
////}
