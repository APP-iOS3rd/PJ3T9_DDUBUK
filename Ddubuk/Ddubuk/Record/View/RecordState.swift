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

enum RecordActiveAlert {
    case deleteTracking, saveRecording
}

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
    
    @State private var overlayHeight: CGFloat = 170 // 오버레이 뷰의 높이 상태 변수
    @State private var showDetailedInfo = false // 상세 정보 표시 여부 상태 변수
    @State private var isDeleteTrackingEnabled: Bool = false // "Delete tracking" 버튼 활성화 상태 제어 변수
    @State private var isStartPressed: Bool = false // "Start" 버튼이 눌렸는지 여부
    @State private var showingDeleteAlert = false
    @State private var showingSaveAlert = false
    @State private var stepsCount: Int = 0
    
    @State private var resetStateCallback: (() -> Void)?
    
    @GestureState private var dragAmount = CGSize.zero // 드래그 양을 추적하는 상태 변수
    
    
    @State var route: Route = Route(
        title: "아름다운 산책로",
        coordinates: [Coordinate(latitude: 37.5665, longitude: 126.9780, timestamp: Date())],
        imageUrls: ["images-1", "images-2"],
        address: "서울특별시 중구",
        memo: "맑은 날 산책하기 좋음",
        types: [WalkingType.Dog],
        duration: 30,
        distanceTraveled: 1.5,
        recordedDate: Date(),
        stepsCount: 0
    )
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 392, height: overlayHeight)
                .foregroundColor(Color.white.opacity(0.95))
                .shadow(radius: 8)
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        if showDetailedInfo {
                            
                            Rectangle()
                                .frame(width: 24, height: 5)
                                .foregroundColor(Color(UIColor.systemGray5))
                                .cornerRadius(3)
                                .padding(8)
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Stopwatch(secondsElapsed: stopwatchViewModel.secondsElapsed)
                                Spacer()
                                Text("\(locationManager.distanceTraveled, specifier: "%.2f")m")
                                    .font(.custom("NotoSansKR-Bold", size: 24))
                                Spacer()
                                Button(action: {
                                    showDetailedInfo = false
                                    overlayHeight = 240 // 오버레이 높이 증가
                                }) {
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.black)
                                        .padding(15)
                                        .background(Color(UIColor.systemGray6))
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                //
                                
                                Spacer()
                            }
                            
                            .gesture(
                                DragGesture()
                                    .onEnded({ value in
                                        // 드래그가 끝났을 때 실행할 코드
                                        if value.translation.height < 0 {
                                            // 위로 드래그할 때 상세 정보 숨기고 기본 정보 및 커스텀 버튼 표시
                                            withAnimation {
                                                showDetailedInfo = false // 상세 정보 숨김
                                                overlayHeight = 240 // 오버레이 뷰의 높이를 기본 높이로 설정
                                            }
                                        }
                                    })
                            )
                            
                        } else {
                            // 기본 정보를 표시하는 뷰
                            Rectangle()
                                .frame(width: 24, height: 5)
                                .foregroundColor(Color(UIColor.systemGray))
                                .cornerRadius(3)
                                .padding(5)
                            Spacer()
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Stopwatch(secondsElapsed: stopwatchViewModel.secondsElapsed)
                                    Text("시간")
                                        .font(.custom("NotoSansKR-Medium", size: 16))
                                }
                                .frame(minWidth: 0, maxWidth: .infinity) // 최대한의 공간을 차지하도록 설정
                                
                                Spacer()
                                
                                VStack {
                                    Text("\(locationManager.distanceTraveled, specifier: "%.2f")m")
                                        .font(.custom("NotoSansKR-Bold", size: 24))
                                    Text("거리")
                                        .font(.custom("NotoSansKR-Medium", size: 16))
                                }
                                .frame(minWidth: 0, maxWidth: .infinity) // 최대한의 공간을 차지하도록 설정
                                
                                Spacer()
                                
                                VStack {
                                    Text("\(route.stepsCount)")
                                        .font(.custom("NotoSansKR-Bold", size: 24))
                                    Text("걸음수")
                                        .font(.custom("NotoSansKR-Medium", size: 16))
                                }
                                .frame(minWidth: 0, maxWidth: .infinity) // 최대한의 공간을 차지하도록 설정
                                
                                Spacer()
                            }
                        }
                        Spacer()
                        
                        
                        
                        VStack {
                            if !showDetailedInfo {
                                
                                if isStartPressed {
                                    Button("Delete tracking") {
                                        showingDeleteAlert = true
                                    }
                                    .font(.custom("NotoSansKR-Medium", size: 16))
                                    .disabled(!isStopped) // 'isStopped'가 true일 때만 버튼을 활성화합니다.
                                    .foregroundColor(isStopped ? .red : .gray) // 'isStopped'에 따라 색상을 변경합니다.
                                    .padding(.bottom, 5)
                                    .alert("삭제하시겠습니까?", isPresented: $showingDeleteAlert) {
                                        Button("Cancel", role: .cancel) { }
                                        Button("삭제하기", role: .destructive) {
                                            deleteRecordingState()
                                        }
                                    }
                                    
                                    Divider()
                                }
                                
                                HStack(spacing: 20) {
                                    if !isRecording && !isStopped {
                                        // 시작 버튼: 녹화가 시작되지 않았고, 완전히 중지되지 않았을 때만 표시
                                        CustomButton(title: "Start", systemImage: "play.fill", color: Color("MainColor"), isDisabled: isRecording) {
                                            isRecording = true
                                            isPaused = false
                                            isStopped = false
                                            self.walkStartTime = Date()
                                            stopwatchViewModel.activeStopWatch()
                                            overlayHeight = 120 // 오버레이 뷰의 높이를 줄임
                                            showDetailedInfo = true // 상세 정보 표시
                                            isStartPressed = true // "Start" 버튼이 눌렸음을 표시
                                        }
                                    } else if isRecording && !isPaused {
                                        // 정지 버튼: 녹화 중이고 일시 정지 상태가 아닐 때만 표시
                                        CustomButton(title: "Stop", systemImage: "pause.fill", color: Color("MainColor"), isDisabled: !isRecording) {
                                            isPaused = true
                                            stopwatchViewModel.toggleStopWatch()
                                            isStopped = true // "Stop" 버튼을 누르면 isStopped를 true로 설정
                                            isDeleteTrackingEnabled = true // "Delete tracking" 버튼 활성화
                                        }
                                    } else if isPaused {
                                        // 일시 정지 상태일 때 Resume과 Save 버튼 표시
                                        CustomButton(title: "Resume", systemImage: "play.fill", color: Color(UIColor.systemGray5), isDisabled: !isPaused) {
                                            isPaused = false
                                            isRecording = true
                                            stopwatchViewModel.toggleStopWatch()
                                        }
                                        
                                        CustomButton(title: "Save", systemImage: "stop.fill", color: Color("MainColor"), isDisabled: !isPaused) {
                                            showingSaveAlert = true
                                        }
                                        .alert(isPresented: $showingSaveAlert) { // 알림창을 표시하는 조건
                                            Alert(
                                                title: Text("이 기록을 저장하시겠습니까?"),
                                                primaryButton: .default(Text("저장하기")) {
                                                    isStopped = true
                                                    isRecording = false
                                                    isPaused = false
                                                    stopwatchViewModel.completeTask()
                                                    saveRecording()
                                                },
                                                secondaryButton: .cancel()
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                        
                    }
                )
                .animation(.easeInOut, value: overlayHeight) // 오버레이 뷰의 높이 변경에 애니메이션 적용
                .gesture(
                    DragGesture()
                        .onEnded({ value in
                            // 드래그가 끝났을 때 실행할 코드
                            if value.translation.height > 0 {
                                // 아래로 드래그할 때 상세 정보 표시
                                withAnimation {
                                    showDetailedInfo = true // 상세 정보 표시
                                    overlayHeight = 120 // 오버레이 뷰의 높이를 확대
                                }
                            }
                        })
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
        .fullScreenCover(isPresented: $isRecordCompleteViewPresented, onDismiss: {
            self.deleteRecordingState()
        }) {
            // RecordCompleteView 호출 시, stepsCount를 전달
            RecordCompleteView(
                duration: stopwatchViewModel.secondsElapsed,
                distanceTraveled: self.locationManager.distanceTraveled,
                coordinates: self.locationManager.coordinates,
                route: self.$route,
                healthManager: healthManager,
                locationManager: locationManager,
                walkStartTime: self.walkStartTime ?? Date(),
                walkEndTime: Date(),
                stepsCount: self.stepsCount, // 걸음수 전달
                    deleteRecordingAction: {
                        self.deleteRecordingState()
                    }
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
                }
            }
        }
    }
    
    private func deleteRecordingState() {
        // 스톱워치 초기화
        stopwatchViewModel.resetStopwatch()
        
        // 위치 데이터 초기화
        locationManager.resetData() // 이 메서드는 LocationManager 클래스에 구현되어 있어야 합니다.
        
        // 기타 상태 변수 초기화
        isRecording = false
        isPaused = false
        isStopped = false
        isStartPressed = false
        showDetailedInfo = false
        currentMeter = "0"
        overlayHeight = 170 // 초기 설정값으로 변경
        route.stepsCount = 0
        // 기타 필요한 상태 변수들을 여기서 초기화합니다.
        
        print("Tracking deleted and data reset")
    }
    
    func loadStepsData() {
        guard let walkStartTime = self.walkStartTime else { return }
        
        healthManager.readStepCount(startDate: walkStartTime, endDate: Date()) { steps, error in
            if let error = error {
                print("걸음수 조회 실패: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.stepsCount = Int(steps)
                }
            }
        }
    }
}

