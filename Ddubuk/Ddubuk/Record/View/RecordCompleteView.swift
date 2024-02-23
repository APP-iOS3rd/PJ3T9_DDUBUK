//
//  RecordCompleteView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/30/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestoreSwift

enum ActiveAlert {
    case saveConfirmation, warning
}

struct RecordCompleteView: View {
    
    var duration: Int
    var distanceTraveled: Double
    var coordinates: [Coordinate]
    @Binding var route: Route
    @State var selectedRoute: Route? = nil
    @EnvironmentObject var viewModel: RecordViewModel
    //    @State private var title: String = ""
    @State private var SaveAlertPresented: Bool = false
    @State private var WarningAlertPresented: Bool = false
    @State private var activeAlert: ActiveAlert = .saveConfirmation
    @State private var showAlert: Bool = false
    
    @StateObject var stopwatchViewModel = StopwatchViewViewModel.shared
    
    @ObservedObject var healthManager: HealthManager
    
    @ObservedObject var locationManager: LocationManager
    @State var title: String = ""
    @State var memo: String = ""
    @State private var showingImagePicker = false
    @State private var isSaving: Bool = false
    @State private var inputImages: [UIImage] = []
    @State private var selectedTypes: [WalkingType] = []
    @State private var editingImageIndex: Int? = nil
    
    var walkStartTime: Date // 산책 시작 시간
    var walkEndTime: Date // 산책 종료 시간
    @State private var stepsCount: Int = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    let storage = Storage.storage()
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                
                RecordMap(
                    userLocations: viewModel.userLocations,
                    isRecording: viewModel.isRecording,
                    timerState: viewModel.timerState
                )
                .frame(height: 300)
                Divider()
                    .frame(minHeight: 3)
                    .overlay(Color.black)
                    .padding(-9)
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    
                    HStack{
                        Text("날짜:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(getCurrentDateTime())")
                    }
                    
                    // 주소 정보를 표시하는 부분 추가
                    HStack {
                        Text("주소:")
                            .fontWeight(.bold)
                            .padding(.top, 5)
                        Spacer()
                        Text(route.address ?? "주소 정보 없음")
                            .padding(.top, 5)
                    }
                    // 타입 표시 추가
                    HStack{
                        ForEach(route.types, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    
                    
                    VStack {
                        HStack{
                            Text("제목:")
                                .fontWeight(.bold)
                            TextField("제목을 입력해 주세요.", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            
                        }
                        HStack{
                            Text("설명:")
                                .fontWeight(.bold)
                            TextField("산책설명", text: $memo)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 30) {
                        Spacer()
                        VStack {
                            Text("산책거리")
                                .fontWeight(.bold)
                            Text("\(route.distanceTraveled, specifier: "%.2f")M")
                        }
                        
                        VStack {
                            Text("걸음수")
                                .fontWeight(.bold)
                            Text("\(stepsCount)")
                        }
                        
                        VStack {
                            Text("총 시간")
                                .fontWeight(.bold)
                            //                            Text("\(dummyData.totalTime)")
                            //                                .fontWeight(.bold)
                            Text("\(formatTime(duration))")
                            
                        }
                        Spacer()
                    }
                    
                    Text("테마")
                        .fontWeight(.bold)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem()]) {
                            ForEach(WalkingType.allCases, id: \.self) { type in
                                Rectangle()
                                    .frame(width: 50, height: 20)
                                    .foregroundColor(self.selectedTypes.contains(type) ? Color.blue : Color.gray)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        if self.selectedTypes.contains(type) {
                                            self.selectedTypes.removeAll { $0 == type }
                                        } else {
                                            self.selectedTypes.append(type)
                                        }
                                    }
                                    .padding()
                            }
                        }
                        .padding(.leading, -16)
                    }
                    

                    TagView()
         
                    Text("사진(최대 9장)")
                                        .fontWeight(.bold)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(inputImages.indices, id: \.self) { index in
                            Button(action: {
                                self.editingImageIndex = index // 수정할 이미지의 인덱스 설정
                                self.showingImagePicker = true // 이미지 피커 표시
                            }) {
                                Image(uiImage: inputImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                    .cornerRadius(10)
                                    .clipped()
                            }
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                        }
                        
                        if inputImages.count < 9 {
                            Button(action: {
                                self.editingImageIndex = nil // 새 이미지 추가 모드
                                self.showingImagePicker = true
                            }) {
                                Rectangle()
                                    .foregroundColor(Color.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                    .cornerRadius(10)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                    )
                            }
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top, 10)
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(images: $inputImages, editingIndex: $editingImageIndex)
                    }
                    
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    if self.isValidData() {
                        self.activeAlert = .saveConfirmation
                        self.showAlert = true
                    } else {
                        self.activeAlert = .warning
                        self.showAlert = true
                    }
                }) {
                    Text("산책로 저장하기")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.indigo)
                        .foregroundColor(Color.white)
                        .cornerRadius(15)
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .saveConfirmation:
                        return Alert(
                            title: Text("저장하시겠습니까?"),
                            primaryButton: .default(Text("저장하기")) {
                                self.saveRoute()
                            },
                            secondaryButton: .cancel()
                        )
                    case .warning:
                        return Alert(title: Text("경고"), message: Text("저장할 데이터가 없습니다."), dismissButton: .default(Text("확인")))
                    }
                    if isSaving {
                        ProgressView("저장 중...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .zIndex(1) // 다른 뷰 위에 표시되도록 z-index 설정
                    }
                }
                
            }
            .navigationBarTitle(Text("기록 완료"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button {
                WarningAlertPresented = true
            } label: {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
            }
                .alert(isPresented: $WarningAlertPresented) {
                    Alert(
                        title: Text("경고"),
                        message: Text("이 활동 기록을 정말로 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제하기")) {
                            // LocationManager의 resetData 함수 호출
                            self.locationManager.resetData()
                            // 이전 화면으로 돌아가기
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .default(Text("취소"))
                    )
                }
            )
        }
        .onAppear {
            loadStepsData()
        }
    }
    func loadImage() {
        // 이미지 선택 후 처리 로직
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(NSError(domain: "uploadImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지를 JPEG 데이터로 변환하는 데 실패했습니다."])))
            return
        }
        
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(NSError(domain: "uploadImageError", code: -2, userInfo: [NSLocalizedDescriptionKey: "이미지 URL을 가져오는 데 실패했습니다."])))
                }
            }
        }
    }
    
    func uploadImages(_ images: [UIImage], completion: @escaping (Result<[URL], Error>) -> Void) {
        var uploadedUrls = [URL]()
        let uploadGroup = DispatchGroup()
        
        for image in images {
            uploadGroup.enter()
            uploadImage(image) { result in
                switch result {
                case .success(let url):
                    uploadedUrls.append(url)
                case .failure(let error):
                    print("Error uploading image: \(error)")
                }
                uploadGroup.leave()
            }
        }
        
        uploadGroup.notify(queue: .main) {
            if uploadedUrls.count == images.count {
                completion(.success(uploadedUrls))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "모든 이미지가 성공적으로 업로드되지 않았습니다."])))
            }
        }
    }
    
    func getCurrentDateTime() -> String {
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일  HH시 mm분"
        let dateString = formatter.string(from: currentDate)
        
        return dateString
    }
    
    func saveRouteToFirestore(route: Route) {
        // Firestore에 Route 객체를 저장
        print("저장 전 duration 값: \(route.duration)")
        
        FireStoreManager.shared.addRoute(route: route, documentName: route.title) { error in
            if let error = error {
                print("Error adding route: \(error)")
            } else {
                // Firestore에 저장이 성공하면, 현재 저장된 데이터를 초기화
                self.locationManager.resetData()
                self.presentationMode.wrappedValue.dismiss()
                print("Firestore에 저장된 duration 값: \(route.duration)")
            }
        }
    }
    
    // 데이터 유효성 검사 함수
    private func isValidData() -> Bool {
        // 예시: title과 memo가 비어있지 않은지, tempCoordinates가 비어있지 않은지 등을 검사
        return !self.title.isEmpty && !self.memo.isEmpty && !self.locationManager.tempCoordinates.isEmpty
    }
    
    private func saveRoute() {
        // 주소 변환 작업을 시작합니다.
        LocationManager.changeToAddress(location: self.locationManager.changeToClLocation(latitude: self.locationManager.currentLocation?.latitude, longitude: self.locationManager.currentLocation?.longitude)) { address in
            // 이미지 업로드 후 URL을 받아옵니다.
            if !self.inputImages.isEmpty {
                self.uploadImages(self.inputImages) { result in
                    switch result {
                    case .success(let urls):
                        // 업로드된 이미지 URL들을 사용하여 Route 객체를 업데이트합니다.
                        let updatedRoute = Route(
                            title: self.title,
                            coordinates: self.locationManager.tempCoordinates,
                            imageUrls: urls.map { $0.absoluteString }, // 업로드된 이미지 URL들
                            address: address,
                            memo: self.memo,
                            types: self.selectedTypes,
                            duration: self.route.duration,
                            distanceTraveled: self.route.distanceTraveled,
                            recordedDate: Date() ,
                            stepsCount: self.stepsCount
                        )
                        // Firestore에 Route 객체를 저장합니다.
                        self.saveRouteToFirestore(route: updatedRoute)
                    case .failure(let error):
                        print("Image upload error: \(error)")
                    }
                }
            } else {
                // 이미지가 선택되지 않았을 경우의 로직
                // 이미지 URL 배열이 비어있는 경우를 처리합니다.
                let updatedRoute = Route(
                    title: self.title,
                    coordinates: self.locationManager.tempCoordinates,
                    imageUrls: [], // 이미지가 없으므로 빈 배열
                    address: address,
                    memo: self.memo,
                    types: self.selectedTypes,
                    duration: self.route.duration,
                    distanceTraveled: self.route.distanceTraveled,
                    recordedDate: Date(),
                    stepsCount: self.stepsCount
                )
                print("\(updatedRoute)")
                self.saveRouteToFirestore(route: updatedRoute)
                print("No image selected")
                
            }
        }
    }
    // 시간 포맷팅을 위한 함수
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // 걸음수 데이터를 읽는 함수
    func loadStepsData() {
        healthManager.readStepCount(startDate: walkStartTime, endDate: walkEndTime) { steps, error in
            DispatchQueue.main.async {
            // 임의로 걸음수 데이터 생성 
//            stepsCount = 1
                if let error = error {
                    print("걸음수 조회 실패: \(error.localizedDescription)")
                } else {
                    self.stepsCount = Int(steps)
                }
            }
        }
    }
}

//#Preview {
//    RecordCompleteView()
//}
