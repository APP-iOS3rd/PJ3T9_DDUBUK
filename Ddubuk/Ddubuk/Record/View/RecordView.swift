//
//  RecordView.swift
//  Ddubuk
//
//  Created by lkh on 1/22/24.
//

import SwiftUI
import Firebase

// MARK: - RecordView
struct RecordView: View {
//    // MARK: Environment
//    @Environment(\.scenePhase) var scenePhase
//    
//    // MARK: Object
//    @StateObject private var viewModel = RecordViewModel()
//    
//    // MARK: State
    @State private var showBottom: Bool = false
//    @State private var isGoSaveView: Bool = false

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: RecordViewModel
    
    @ObservedObject var routes = FireStoreManager.shared
    @StateObject var locationManager = LocationManager()
    
    @State var address: String = ""
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var currentLocationDescription: String = "Not Available"
    @State var timerStart: Date = Date()
    @State var timerString: String = "00:00"
    @State var timer: Timer? = nil
    @State var elapsedTime: Int = 0
    @State var selectedRoute: Route? = nil
    @State private var isRecordCompleteViewPresented = false
    
    
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center)  {
                // MARK: Map
                RecordMap(userLocations: viewModel.userLocations, isRecording:
                            viewModel.isRecording, timerState: viewModel.timerState)
                .onAppear { // 나타날 때
                    viewModel.startUpdatingLocation()
                    print("뷰 위치 업데이트 실행")
                }
                
                .onDisappear { // 사라질 때
                    viewModel.stopUpdatingLocation()
                    print("위치 업데이트 중지")
                }
                .ignoresSafeArea()
                
                //                // Test
                //                    .onChange(of: scenePhase) { phase in
                //                        switch phase {
                //                        case .active:
                //                            print("Active")
                //                        case .inactive:
                //                            print("Inactive")
                //                        case .background:
                //                            print("Background")
                //                        default:
                //                            print("scenePhase err")
                //                        }
                //                    }
                //                
                //                // Map 정보창
                RecordState(
                    isRecording: $viewModel.isRecording,
                    showBottom: $showBottom,
                    //                    realTime: $viewModel.recordingTime,
                    currentMeter: $viewModel.recordingMeter
                    //                    timerState: $viewModel.timerState,
                    //                    startTimer: { viewModel.startTimer() },
                    //                    pauseTimer: { viewModel.pauseTimer() },
                    //                    cancleTimer: { viewModel.clearTimer() }
                )
                
                
            } // ZStack
            .navigationDestination(isPresented: $isRecordCompleteViewPresented) {
                // 필요한 데이터만 포함하여 Route 객체 생성
                let route = Route(
                    title: "", // RecordCompleteView에서 설정
                    coordinates: locationManager.tempCoordinates, // 실제 좌표 데이터
                    imageUrl: nil, // RecordCompleteView에서 이미지 업로드 후 설정
                    address: nil, // RecordCompleteView에서 주소 설정
                    memo: "", // RecordCompleteView에서 설정
                    types: [], // RecordCompleteView에서 설정
                    duration: timerString, // 타이머 정보
                    distanceTraveled: locationManager.distanceTraveled // 이동 거리 정보
                )
                RecordCompleteView(
                    timerString: timerString,
                    distanceTraveled: locationManager.distanceTraveled,
                    coordinates: locationManager.tempCoordinates, // 실제 좌표 데이터
                    route: route,
                    locationManager: locationManager
                )
                .environmentObject(viewModel)
                .navigationBarBackButtonHidden()
            }
        }
        // MARK:
        .sheet(isPresented: $showBottom) {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
//                    Spacer()
//                    
//                    Text(viewModel.recordingTime.asTimestamp)
//                        .bold()
//                        //.foregroundColor(.black)
//                    
//                    Spacer()
//
//                    Text(viewModel.recordingMeter)
//                        .bold()
//                        //.foregroundColor(.black)
//                    
//                    Spacer()
                    Text("이동 시간: \(timerString)")
                        .padding()
                    Spacer()
                    Text("이동 거리: \(locationManager.distanceTraveled, specifier: "%.2f") 미터")
                        .padding()
                }
                
                Spacer()
                
                Button("기록 저장하기") {
                    showBottom.toggle() // 바텀 뷰 내리고
                    isRecordCompleteViewPresented.toggle() // 저장 뷰로 이동
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
            }
            .presentationDetents([.height(200)])
        }
        
        .onAppear {
            viewModel.getLocationUsagePermission()
        } // onAppear
        
    } // body
}

//#Preview {
//    RecordView()
//}
