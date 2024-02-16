//
//  RecordView.swift
//  Ddubuk
//
//  Created by lkh on 1/22/24.
//

import SwiftUI
import Firebase

struct RecordView: View {
    @State private var showBottom: Bool = false

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
            
                RecordState(
                    isRecording: $viewModel.isRecording,
                    showBottom: $showBottom,
                    currentMeter: $viewModel.recordingMeter
                )
                
                
            } // ZStack
            .navigationDestination(isPresented: $isRecordCompleteViewPresented) {
//                // 필요한 데이터만 포함하여 Route 객체 생성
//                let route = Route(
//                    title: "", // RecordCompleteView에서 설정
//                    coordinates: locationManager.tempCoordinates, // 실제 좌표 데이터
//                    imageUrls: [], // RecordCompleteView에서 이미지 업로드 후 설정
//                    address: address,
//                    memo: "", // RecordCompleteView에서 설정
//                    types: [], // RecordCompleteView에서 설정
//                    duration: elapsedTime,// 타이머 정보
//                    distanceTraveled: locationManager.distanceTraveled, // 이동 거리 정보
//                    recordedDate: Date()
//                )
//                RecordCompleteView(
//                    elapsedTime: elapsedTime,
//                    distanceTraveled: locationManager.distanceTraveled,
//                    coordinates: locationManager.tempCoordinates, // 실제 좌표 데이터
//                    route: self.$route,
//                    locationManager: locationManager
//                )
//                .environmentObject(viewModel)
//                .navigationBarBackButtonHidden()
            }
        }
        // MARK:
        .sheet(isPresented: $showBottom) {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    Text("이동 시간: \(timerString)")
                        .padding()
                    Spacer()
                    Text("이동 거리: \(locationManager.distanceTraveled, specifier: "%.2f") 미터")
                        .padding()
                }
                
                Spacer()
                
                Button("기록 저장하기") {
                    // Coordinate 타입의 현재 위치를 CLLocation 타입으로 변환합니다.
                    if let currentLocation = locationManager.currentLocation {
                        let clLocation = locationManager.convertCoordinateToCLLocation(coordinate: currentLocation)
                        
                        // 주소 변환 작업을 시작합니다.
                        LocationManager.changeToAddress(location: clLocation) { address in
                            // 조회된 주소를 포함하여 Route 객체를 생성합니다.
                            let route = Route(
                                title: "", // RecordCompleteView에서 설정
                                coordinates: locationManager.tempCoordinates, // 실제 좌표 데이터
                                imageUrls: [], // RecordCompleteView에서 이미지 업로드 후 설정
                                address: address, // 조회된 주소
                                memo: "", // RecordCompleteView에서 설정
                                types: [], // RecordCompleteView에서 설정
                                duration: elapsedTime, // 타이머 정보
                                distanceTraveled: locationManager.distanceTraveled, // 이동 거리 정보
                                recordedDate: Date() // 기록 날짜
                            )
                            // RecordCompleteView로 넘어가기 전에 isRecordCompleteViewPresented 상태를 변경합니다.
                            self.isRecordCompleteViewPresented = true
                            // 생성된 route 객체를 RecordCompleteView에 전달합니다.
                            self.selectedRoute = route
                        }
                    }
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

