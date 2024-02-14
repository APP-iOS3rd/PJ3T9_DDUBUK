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
            
            RoundedRectangle(cornerRadius: 1)
                
                .frame(width: 270, height: 84)
                .foregroundColor(Color.white.opacity(0.8))
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        
                        HStack(alignment: .center, spacing: 0) {
                            HStack {
                                Spacer()
                                Text("이동 시간: \(timerString)")
                                    .font(.system(size: 16))
                                Spacer()
                                //                                Text("이동 거리: \(currentMeter != "0M" ? currentMeter : "0M")")
                                Text("\(currentMeter)")
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            .padding()
                        }
                       
                        
                        stateRecordButton()
                        Spacer()
                        
                    }
                ) // overlay
        } // VStack
        .sheet(isPresented: $isRecordCompleteViewPresented) {
            // Route 객체 생성
            let newRoute = Route(
                title: self.locationManager.title, // 수정됨
                coordinates: self.locationManager.coordinates, // 수정됨
                imageUrls: self.locationManager.imageUrl != nil ? [self.locationManager.imageUrl!.absoluteString] : [], // 수정됨
                address: self.locationManager.address ?? "", // 수정됨
                memo: self.locationManager.memo, // 수정됨
                types: self.locationManager.selectedTypes, // 수정됨
                duration: self.locationManager.elapsedTime, // 수정됨
                distanceTraveled: self.locationManager.distanceTraveled, // 수정됨
                recordedDate: self.locationManager.startTime ?? Date() // 수정됨
            )
            
            // 필요한 데이터만 전달하여 RecordCompleteView 초기화
            RecordCompleteView(
                elapsedTime: self.locationManager.elapsedTime, // 수정됨
                distanceTraveled: self.locationManager.distanceTraveled, // 수정됨
                coordinates: self.locationManager.coordinates, // 수정됨
                route: newRoute,
                locationManager: locationManager
            )
        }
    } // body
    
    // MARK: - ViewBuilder
    // ..
    // MARK: - stateRecordButton
    @ViewBuilder
    private func stateRecordButton() -> some View {
        VStack(spacing: 0) {
            
            // 산책 중이 아니고, 일시정지 상태도 아닐 때만 '산책하기' 버튼 표시
            if !isRecording && !isPaused {
                
                Button(action: {
                    startRecording()
                }) {
                    Text("산책하기")
                }
                .padding(.horizontal)
                 // 버튼을 가운데 정렬하기 위해
                
            } else {
                // 산책 중이거나 일시정지 상태일 때 나타날 버튼들
                HStack(alignment: .center, spacing: 10) {
                    if isPaused {
                        Button(action: {
                            resumeRecording()
                        }) {
                            Text("이어하기")
                        }
                    } else {
                        Button(action: {
                            pauseRecording()
                        }) {
                            Text("산책정지")
                        }
                        .disabled(!isRecording) // isRecording이 false일 때 비활성화
                    }
                    
                    Button(action: {
                        saveRecording()
                    }) {
                        Text("저장")
                    }
                    .disabled(!isPaused) // 산책이 일시정지 상태가 아니라면 비활성화
                    
                    Button(action: {
                        resetRecording()
                    }) {
                        Text("초기화")
                    }
                    .disabled(!isPaused) // 산책이 일시정지 상태가 아니라면 비활성화
                }
                .padding(.horizontal)
            }
        }
    }

    // 산책 시작 로직
    private func startRecording() {
        self.locationManager.startTimer()
        self.isRecording = true
        self.isPaused = false
        self.elapsedTime = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.elapsedTime += 1
                self.timerString = self.formatTime(self.elapsedTime)
            }
        }

    // 일시정지 로직
    private func pauseRecording() {
        self.timer?.invalidate()
        self.isPaused = true
        self.isRecording = false
        self.locationManager.stopTimer()
    }
    
    // 이어하기 로직
    private func resumeRecording() {
        self.isPaused = false
        self.isRecording = true
        // 타이머를 다시 시작하지만, elapsedTime는 일시정지 시점의 값을 유지
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
            self.timerString = self.formatTime(self.elapsedTime)
        }
        self.locationManager.resumeLocationUpdates()
    }

    // 저장 로직
    private func saveRecording() {
        self.locationManager.stopTimer()
        self.timer?.invalidate()
        self.timer = nil
        self.isRecordCompleteViewPresented = true
        self.isRecording = false
        self.isPaused = false
        // 저장 시점의 elapsedTime을 사용하여 최종 시간을 기록
        print("Save button clicked")
        print("Coordinates saved: \(self.locationManager.tempCoordinates.count)")
        print("Duration saved: \(self.formatTime(self.elapsedTime))")
        print("Distance saved: \(self.locationManager.tempDistanceTraveled)")
        // 데이터 검증 로직
        if locationManager.tempCoordinates.count != 0 {
            print("데이터가 준비되었습니다.")
            self.isRecordCompleteViewPresented = true
        } else {
            print("데이터가 준비되지 않았습니다. 데이터를 확인해주세요.")
        }
        self.elapsedTime = 0 // 저장 후 elapsedTime을 0으로 리셋
        self.timerString = "00:00" // 타이머 문자열도 리셋
    }

    // 초기화 로직
    private func resetRecording() {
        self.locationManager.resetData()
        self.elapsedTime = 0 // 타이머 누적 시간 초기화
        self.isRecording = false
        self.isPaused = false
        self.timer?.invalidate() // 타이머를 중지
        self.timer = nil // 타이머 인스턴스를 nil로 설정
        self.timerString = "00:00" // 타이머 문자열 리셋
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
