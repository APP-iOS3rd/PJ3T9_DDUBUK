//
//  RecodState.swift
//  Ddubuk
//
//  Created by lkh on 1/22/24.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - PathRecodState
struct RecordState: View {
    // MARK: Binding
    @Binding var isRecording: Bool
    @Binding var showBottom: Bool
    @State private var isPaused: Bool = false
    @State private var isStopped: Bool = false
    @Binding var currentMeter: String
    @State private var isRecordCompleteViewPresented = false
    @StateObject var locationManager = LocationManager()
    @StateObject var stopwatchViewModel = StopwatchViewViewModel.shared
    @StateObject var healthManager = HealthManager()
    @State private var walkStartTime: Date?
    
    @State var route: Route = Route(
        title: "아름다운 산책로",
        coordinates: [Coordinate(latitude: 37.5665, longitude: 126.9780, timestamp: Date())],
        imageUrls: ["images-1", "images-2"],
        address: "서울특별시 중구",
        memo: "맑은 날 산책하기 좋음",
        types: [WalkingType.A],
        duration: 30,
        distanceTraveled: 1.5,
        recordedDate: Date(),
        stepsCount: 0
    )
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 270, height: 84)
                .foregroundColor(Color.white.opacity(0.8))
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        // Stopwatch를 표시합니다.
                        Stopwatch(secondsElapsed: stopwatchViewModel.secondsElapsed)
                        
                        Spacer()
                        
                        // CustomButton을 사용하여 타이머 제어 버튼을 표시합니다.
                        HStack(spacing: 20) {
                            CustomButton(title: "산책 시작", systemImage: "play.fill", color: .green, isDisabled: stopwatchViewModel.isActive) {
                                stopwatchViewModel.activeStopWatch()
                                isRecording = true
                                self.walkStartTime = Date()
                            }
                            
                            CustomButton(title: stopwatchViewModel.isPause ? "산책 재개" : "산책 일시정지", systemImage: stopwatchViewModel.isPause ? "play.fill" : "pause.fill", color: .yellow, isDisabled: !stopwatchViewModel.isActive) {
                                stopwatchViewModel.toggleStopWatch()
                                isRecording = !stopwatchViewModel.isPause
                            }
                            
                            CustomButton(title: "산책 종료", systemImage: "stop.fill", color: .red, isDisabled: !stopwatchViewModel.isActive) {
                                stopwatchViewModel.completeTask()
                                saveRecording() // 산책 기록을 저장합니다.
                                isRecording = false
                            }
                        }
                        
                        Spacer()
                    }
                )
        }
        .onAppear {
            // HealthKit 접근 권한 요청
            healthManager.requestAuthorization { success, error in
                if success {
                    print("HealthKit 접근 권한이 허용되었습니다.")
                } else if let error = error {
                    print("HealthKit 접근 권한 요청 실패: \(error.localizedDescription)")
                }
            }
        }
        .sheet(isPresented: $isRecordCompleteViewPresented) {
            let _ = print("\(stopwatchViewModel.secondsElapsed)")
            RecordCompleteView(
                duration: stopwatchViewModel.secondsElapsed,
                distanceTraveled: self.locationManager.distanceTraveled,
                coordinates: self.locationManager.coordinates,
                route: self.$route,
                healthManager: healthManager,   
                locationManager: locationManager,
                walkStartTime: self.walkStartTime ?? Date(), // 산책 시작 시간
                walkEndTime: Date() // 산책 종료 시간
            )
        }
    }
    // 산책 기록을 저장하는 로직
    private func saveRecording() {
        self.isRecordCompleteViewPresented = true
        self.isRecording = false
        self.isPaused = false
        self.stopwatchViewModel.stopTimer() // `stopwatchViewModel` 사용
        // 저장 시점의 elapsedTime을 사용하여 최종 시간을 기록
        print("Save button clicked")
        print("Coordinates saved: \(self.locationManager.tempCoordinates.count)")
        print("Duration saved: \(stopwatchViewModel.secondsElapsed)") // `stopwatchViewModel`의 `secondsElapsed` 사용
        print("Distance saved: \(self.locationManager.tempDistanceTraveled)")
        // 데이터 검증 로직
        if locationManager.tempCoordinates.count != 0 {
            print("데이터가 준비되었습니다.")
            self.isRecordCompleteViewPresented = true
        } else {
            print("데이터가 준비되지 않았습니다. 데이터를 확인해주세요.")
        }
        guard let walkStart = walkStartTime else {
            print("산책 시작 시간이 설정되지 않았습니다.")
            return
        }
        let walkEnd = Date() // 산책 종료 시간
        // 걸음수 조회
        healthManager.readStepCount(startDate: walkStart, endDate: walkEnd) { steps, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("걸음수 조회 실패: \(error.localizedDescription)")
                } else {
                    print("조회된 걸음수: \(steps)")
                    // 조회된 걸음수를 Route 인스턴스에 저장
                    self.route.stepsCount = Int(steps)
                    
                    if let currentLocation = self.locationManager.currentLocation {
                        // 주소변환부분
                        LocationManager.changeToAddress(location: CLLocation(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)) { address in
                            DispatchQueue.main.async {
                                // 디버깅: 변환된 주소 출력
                                print("\(self.stopwatchViewModel.secondsElapsed)")
                                print("변환된 주소: \(address)")
                                self.route = Route(
                                    title: "", // RecordCompleteView에서 설정
                                    coordinates: self.locationManager.tempCoordinates, // 실제 좌표 데이터
                                    imageUrls: [], // RecordCompleteView에서 이미지 업로드 후 설정
                                    address: address, // 조회된 주소
                                    memo: "", // RecordCompleteView에서 설정
                                    types: [], // RecordCompleteView에서 설정
                                    duration: self.stopwatchViewModel.secondsElapsed, // `stopwatchViewModel`의 `secondsElapsed` 사용
                                    distanceTraveled: self.locationManager.tempDistanceTraveled, // 이동 거리 정보
                                    recordedDate: Date(),
                                    stepsCount: 0
                                    
                                )
                                // RecordCompleteView를 표시하고, newRoute에 주소 포함하여 전달
                                self.isRecordCompleteViewPresented = true
                                // RecordCompleteView 초기화 시 newRoute 전달
                            }
                        }
                    } else {
                        print("현재 위치 정보가 없어 주소 변환을 수행할 수 없습니다.")
                    }
                    
                    //        self.stopwatchViewModel.secondsElapsed = 0 // 저장 후 elapsedTime을 0으로 리셋
                }
            }
        }
    }
}
    // MARK: - ViewBuilder
    // ..
    // MARK: - stateRecordButton
//    @ViewBuilder
//    private func stateRecordButton() -> some View {
//        VStack(spacing: 0) {
//            
//            // 산책 중이 아니고, 일시정지 상태도 아닐 때만 '산책하기' 버튼 표시
//            if !isRecording && !isPaused {
//                
//                Button(action: {
//                    startRecording()
//                    timerViewModel.startTimer()
//                }) {
//                    Text("산책하기")
//                }
//                .padding(.horizontal)
//                // 버튼을 가운데 정렬하기 위해
//                
//            } else {
//                // 산책 중이거나 일시정지 상태일 때 나타날 버튼들
//                HStack(alignment: .center, spacing: 10) {
//                    if isPaused {
//                        Button(action: {
//                            resumeRecording()
//                        }) {
//                            Text("이어하기")
//                        }
//                    } else {
//                        Button(action: {
//                            pauseRecording()
//                            timerViewModel.stopTimer()
//                        }) {
//                            Text("산책정지")
//                        }
//                        .disabled(!isRecording) // isRecording이 false일 때 비활성화
//                    }
//                    
//                    Button(action: {
//                        saveRecording()
//                    }) {
//                        Text("저장")
//                        
//                    }
//                    .disabled(!isPaused) // 산책이 일시정지 상태가 아니라면 비활성화
//                    
//                    Button(action: {
//                        resetRecording()
//                    }) {
//                        Text("초기화")
//                    }
//                    .disabled(!isPaused) // 산책이 일시정지 상태가 아니라면 비활성화
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//    
//    // 산책 시작 로직
//    private func startRecording() {
//        self.isRecording = true
//        self.isPaused = false
//        self.timerViewModel.startTimer() // TimerViewModel을 사용하여 타이머 시작
//    }
//    
//    // 일시정지 로직
//    private func pauseRecording() {
//        self.isPaused = true
//        self.isRecording = false
//        self.timerViewModel.stopTimer() // TimerViewModel을 사용하여 타이머 중지
//    }
//    
//    // 이어하기 로직
//    private func resumeRecording() {
//        self.isPaused = false
//        self.isRecording = true
//        self.locationManager.resumeLocationUpdates()
//        timerViewModel.startTimer() // TimerViewModel을 사용하여 타이머 재시작
//    }
//    
//   // 저장 로직
//    private func saveRecording() {
//        self.isRecordCompleteViewPresented = true
//        self.isRecording = false
//        self.isPaused = false
//        self.timerViewModel.stopTimer()
//        // 저장 시점의 elapsedTime을 사용하여 최종 시간을 기록
//        print("Save button clicked")
//        print("Coordinates saved: \(self.locationManager.tempCoordinates.count)")
//        print("Duration saved: \(self.timerViewModel.formatTime(timerViewModel.elapsedTime))")
//        print("Distance saved: \(self.locationManager.tempDistanceTraveled)")
//        // 데이터 검증 로직
//        if locationManager.tempCoordinates.count != 0 {
//            print("데이터가 준비되었습니다.")
//            self.isRecordCompleteViewPresented = true
//        } else {
//            print("데이터가 준비되지 않았습니다. 데이터를 확인해주세요.")
//        }
//        
//        if let currentLocation = self.locationManager.currentLocation {
//            
//            // 주소변환부분
//            LocationManager.changeToAddress(location: CLLocation(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)) { address in
//                DispatchQueue.main.async {
//                    // 디버깅: 변환된 주소 출력
//                    print("변환된 주소: \(address)")
//                    //                        self.globalAddress = address
//                    route = Route(
//                        title: "", // RecordCompleteView에서 설정
//                        coordinates: self.locationManager.tempCoordinates, // 실제 좌표 데이터
//                        imageUrls: [], // RecordCompleteView에서 이미지 업로드 후 설정
//                        address: address, // 조회된 주소
//                        memo: "", // RecordCompleteView에서 설정
//                        types: [], // RecordCompleteView에서 설정
//                        duration: timerViewModel.elapsedTime, // 타이머 정보
//                        distanceTraveled: self.locationManager.distanceTraveled, // 이동 거리 정보
//                        recordedDate: Date() // 기록 날짜
//                    )
//                    // RecordCompleteView를 표시하고, newRoute에 주소 포함하여 전달
//                    self.isRecordCompleteViewPresented = true
//                    // RecordCompleteView 초기화 시 newRoute 전달
//                }
//            }
//        } else {
//            print("현재 위치 정보가 없어 주소 변환을 수행할 수 없습니다.")
//        }
//        
//        self.timerViewModel.elapsedTime = 0 // 저장 후 elapsedTime을 0으로 리셋
//        self.timerViewModel.timerString = "00:00" // 타이머 문자열도 리셋
//    }
//    
//    // 초기화 로직
//    private func resetRecording() {
//        self.timerViewModel.resetData()
//        self.isRecording = false
//        self.isPaused = false
//        self.timerViewModel.stopTimer()
////        self.timer?.invalidate() // 타이머를 중지
////        self.timer = nil // 타이머 인스턴스를 nil로 설정
//        self.timerViewModel.elapsedTime = 0 // 타이머 누적 시간 초기화
//        self.timerViewModel.timerString = "00:00" // 타이머 문자열 리셋
//    }






//extension Int {
//    // MARK: - asTimestamp
//    var asTimestamp: String {
//        let hour = self / 3600
//        let minute = self / 60 % 60
//        let second = self % 60
//
//        if hour > 0 {
//            return String(format: "%02i:%02i:%02i", hour, minute, second)
//        } else {
//            return String(format: "%02i:%02i", minute, second)
//        }
//    }
//}
