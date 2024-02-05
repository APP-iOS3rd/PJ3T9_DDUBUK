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
//    @Binding var realTime: Int
//    @Binding var timerState: TimerState
    @Binding var currentMeter: String
    @State var timer: Timer? = nil
    @State private var isRecordCompleteViewPresented = false
    @StateObject var locationManager = LocationManager()
    @State var elapsedTime: Int = 0
    @State var timerStart: Date = Date()

    @State var timerString: String = "00:00"
    
    
    
//
//    // MARK: Action
//    var startTimer: (() -> Void)
//    var pauseTimer: (() -> Void)
//    var cancleTimer: (() -> Void)
    // MARK: - View
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 10)
                .padding([.bottom, .horizontal])
                .frame(width: 350, height: 128)
                .foregroundColor(Color.white.opacity(0.8))
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center, spacing: 10) {
//                            Spacer()
//                            Text("산책 시간 \(realTime.asTimestamp)")
//                                .foregroundColor(.black)
//                                .bold()
//                            
//                            Spacer()
//                            
//                            Text(currentMeter != "이동 거리 0미터" ? "이동 거리 \(currentMeter)" : currentMeter)
//                                .foregroundColor(.black)
//                                .bold()
//                            
//                            Spacer()
                            Text("이동 시간: \(timerString)")
                                .padding()
                            Spacer()
//                            Text("이동 거리: \(locationManager.distanceTraveled, specifier: "%.2f") 미터")
                            Text(currentMeter != "이동 거리 0미터" ? "이동 거리 \(currentMeter)" : currentMeter)
                                .padding()
                            
                        }
                        .padding(.horizontal)
                        
                        stateRecordButton()
                        
                    }
                ) // overlay
        } // VStack
        .sheet(isPresented: $isRecordCompleteViewPresented) {
            
            // Route 객체 생성
            let newRoute = Route(
                title: self.locationManager.title, // LocationManager에서 관리하는 제목
                coordinates: self.locationManager.tempCoordinates, // 임시 좌표 배열
                imageUrl: self.locationManager.imageUrl?.absoluteString ?? "", // 이미지 URL 문자열
                address: self.locationManager.address ?? "주소 정보 없음", // 주소
                memo: self.locationManager.memo, // 메모
                types: self.locationManager.selectedTypes, // 선택된 산책 유형
                duration: self.locationManager.durationString, // 지속 시간 문자열
                distanceTraveled: self.locationManager.distanceTraveled // 이동 거리
            )
            
            // 필요한 데이터만 전달하여 RecordCompleteView 초기화
            RecordCompleteView(
                timerString: self.locationManager.durationString,
                distanceTraveled: self.locationManager.distanceTraveled,
                coordinates: self.locationManager.tempCoordinates,
                route: newRoute, // 생성한 Route 객체 전달
                locationManager: locationManager
            )
        }
    
    } // body
    
    // MARK: - ViewBuilder
    // ..
    // MARK: - stateRecordButton
    @ViewBuilder
    private func stateRecordButton() -> some View {
        HStack(alignment: .center, spacing: 10) {
            if isPaused {
                // 이어하기 버튼
                Button(action: {
                    // 타이머 재시작 로직
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        self.elapsedTime += 1
                        self.timerString = formatTime(elapsedTime)
                    }
                    // 위치 추적 재개 (필요한 경우)
                    locationManager.resumeLocationUpdates()
                    
                    self.isPaused = false
                    self.isRecording = true
                }) {
                    Text("이어하기")
                }
            } else {
                // 산책정지 버튼
                Button(action: {
                    self.timer?.invalidate()
                    self.isPaused = true
                    self.isRecording = false
                    // 위치 추적 일시 정지 (필요한 경우)
                    self.locationManager.stopTimer()
                }) {
                    Text("산책정지")
                }
                .disabled(!isRecording) // isRecording이 false일 때 비활성화
            }
            // 저장 버튼
            Button(action: {
                self.locationManager.stopTimer()
                self.timer?.invalidate()
                self.timer = nil
                self.timerString = "00:00"
                self.elapsedTime = 0
                self.isRecordCompleteViewPresented = true
                self.isRecording = false
                self.isPaused = false
                
                print("Save button clicked")
                print("Coordinates saved: \(self.locationManager.tempCoordinates.count)")
                print("Duration saved: \(self.locationManager.tempDurationString)")
                print("Distance saved: \(self.locationManager.tempDistanceTraveled)")
                // 데이터 검증 로직
                if locationManager.tempCoordinates.count != 0 { // isDataReady는 예시입니다. 실제 데이터 상태를 확인하는 로직이 필요합니다.
                        print("데이터가 준비되었습니다.")
                        self.isRecordCompleteViewPresented = true
                    } else {
                        print("데이터가 준비되지 않았습니다. 데이터를 확인해주세요.")
                    }
                }) {
                    Text("저장")
                
            }
            .disabled(!isPaused) // 산책이 일시정지 상태가 아니라면 비활성화

            // 초기화 버튼
            Button(action: {
                self.locationManager.resetData()
                self.timerString = "00:00"
                self.timerStart = Date()
                self.elapsedTime = 0
                self.isRecording = false
                self.isPaused = false
            }) {
                Text("초기화")
            }
            .disabled(!isPaused) // 산책이 일시정지 상태가 아니라면 비활성화

            // 산책하기 버튼
            Button(action: {
                self.locationManager.startTimer()
                self.timerStart = Date().addingTimeInterval(TimeInterval(-self.elapsedTime))
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    let timeInterval = Int(Date().timeIntervalSince(self.timerStart))
                    let minutes = timeInterval / 60
                    let seconds = timeInterval % 60
                    self.timerString = String(format: "%02d:%02d", minutes, seconds)
                }
                self.isRecording = true
                self.isPaused = false
            }) {
                Text("산책하기")
            }
            .disabled(isRecording || isPaused) // 이미 산책 중이거나 일시정지 상태라면 비활성화
        }
        .padding(.horizontal)
    }
    // 시간 포맷팅을 위한 도우미 함수
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
    

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
