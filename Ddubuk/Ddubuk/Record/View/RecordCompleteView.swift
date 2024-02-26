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
    var stepsCount: Int
    
    var deleteRecordingAction: (() -> Void)?
    
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
                    .padding(-9)
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    
                    HStack {
                        
                        
                        Spacer()
                        VStack {
                            Text("\(formatTime(duration))")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Text("총 시간")
                                .font(.system(size: 16))
                        }
                        Spacer()
                        VStack {
                            Text("\(distanceTraveled, specifier: "%.2f")m")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Text("산책거리")
                                .font(.system(size: 16))
                        }
                        Spacer()
                        VStack {
                            Text("\(stepsCount)걸음")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Text("걸음수")
                                .font(.system(size: 16))
                        }
                        Spacer()
                    }
                    
                    Divider()
                        .foregroundColor(Color(UIColor.systemGray))
                    
                    VStack{
                        Text("제목")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("제목을 입력해 주세요.", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(5)
                            .border(Color.black, width: 1)
                            .multilineTextAlignment(.leading)
                    }
                    
                    
                    //                    HStack{
                    //                        Text("날짜:")
                    //                            .fontWeight(.bold)
                    //                        Spacer()
                    //                        Text("\(getCurrentDateTime())")
                    //                    }
                    //
                    //                    // 주소 정보를 표시하는 부분 추가
                    //                    HStack {
                    //                        Text("주소:")
                    //                            .fontWeight(.bold)
                    //                            .padding(.top, 5)
                    //                        Spacer()
                    //                        Text(route.address ?? "주소 정보 없음")
                    //                            .padding(.top, 5)
                    //                    }
                    
                    
                    // 타입 표시 추가
                    //                    HStack{
                    //                        ForEach(route.types, id: \.self) { type in
                    //                            Text(type.rawValue)
                    //                        }
                    //                    }
                    
                    Text("테마 (최대 5개 까지 선택)")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem()]) {
                            ForEach(WalkingType.allCases, id: \.self) { type in
                                Rectangle()
                                    .frame(width: 50, height: 20)
                                    .cornerRadius(5)
                                    .border(Color.black, width: 1)
                                    .foregroundColor(self.selectedTypes.contains(type) ? Color("MainColor") : Color.white)
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
                    VStack{
                        Text("사진(최대 9장)")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        LazyVGrid(columns: columns, spacing: 10) {
                            // 이미지가 채워진 사각형 표시
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
                            
                            // 빈 사각형 표시 (최대 9개까지, 이미 채워진 사각형을 제외한 나머지)
                            ForEach(inputImages.count..<9, id: \.self) { index in
                                Button(action: {
                                    self.editingImageIndex = nil // 새 이미지 추가 모드
                                    self.showingImagePicker = true
                                }) {
                                    Rectangle()
                                        .foregroundColor(Color.clear) // 내부를 투명하게 만듭니다.
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                        .cornerRadius(5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                        .overlay(
                                            index == inputImages.count ? Image(systemName: "plus").foregroundColor(.black).fontWeight(.bold) : nil
                                        )
                                }
                                .background(Color.white)
                                .cornerRadius(5)
                            }
                        }
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker(images: $inputImages, editingIndex: $editingImageIndex)
                        }
                    }
                    
                    VStack{
                        Text("메모")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("산책로에 대한 설명을 적어주세요", text: $memo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(5)
                            .border(Color.black, width: 1)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(24)
                
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
                    Text("Save")
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                        .padding()
                        .frame(width: 380, height: 40)
                        .background(Color("MainColor"))
                        .foregroundColor(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .saveConfirmation:
                        return Alert(
                            title: Text("기록을 완료하시겠습니까?"),
                            primaryButton: .default(Text("기록하기")) {
                                self.saveRoute() // 비동기처리 계획
                                
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
                .foregroundColor(.red)
                .alert(isPresented: $WarningAlertPresented) {
                    Alert(
                        title: Text("삭제 확인"),
                        message: Text("이 기록을 완전히 지우시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            // 삭제 로직 실행
                            deleteRecordingAction?()
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
                                
            )
        }
        .onAppear {
//            loadStepsData()
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
    
    //    private func deleteRecording() {
    //            // locationManager 및 기타 상태 초기화 로직
    //            locationManager.resetData()
    //            // 기타 필요한 상태 변수 초기화...
    //
    //            // 이전 화면으로 돌아가기
    //            presentationMode.wrappedValue.dismiss()
    //        }
}

//#Preview {
//    RecordCompleteView()
//}
