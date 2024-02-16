//
//  RecordCompleteView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/30/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestoreSwift

struct RecordCompleteView: View {
    var timerString: String
    var distanceTraveled: Double
    var coordinates: [Coordinate]
    var route: Route
    @State var selectedRoute: Route? = nil
    @EnvironmentObject var viewModel: RecordViewModel 
    //    @State private var title: String = ""
    @State private var SaveAlertPresented: Bool = false
    @State private var WarningAlertPresented: Bool = false
    
    @ObservedObject var locationManager: LocationManager
    @State var title: String = ""
    @State var memo: String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var selectedTypes: [WalkingType] = []
    
    @Environment(\.presentationMode) var presentationMode
    
    let storage = Storage.storage()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                
                RecordMap(
                                    userLocations: viewModel.userLocations,
                                    isRecording: viewModel.isRecording,
                                    timerState: viewModel.timerState
                                )
                .frame(height: 300)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    Divider()
                        .frame(minHeight: 3)
                        .overlay(Color.black)
                    
                    HStack {
                        Text("날짜:")
                            .fontWeight(.bold)
                        Text("\(getCurrentDateTime())")
                            .fontWeight(.bold)
                        
                        // 주소 정보를 표시하는 부분 추가
                        if let address = route.address {
                            Text("주소: \(address)")
                                .padding(.top, 5)
                        }
                        // 타입 표시 추가
                        HStack{
                            ForEach(route.types, id: \.self) { type in
                                Text(type.rawValue)
                            }
                        }
                    }
                    
                    HStack {
                        Text("제목:")
                            .fontWeight(.bold)
                        TextField("제목을 입력해 주세요.", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("메모:")
                            .fontWeight(.bold)
                        TextField("메모하기", text: $memo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    HStack(spacing: 30) {
                        VStack {
                            Text("산책거리")
                                .fontWeight(.bold)
//                            Text("\(dummyData.walkDistance)km")
//                                .fontWeight(.bold)
                            Text("이동 거리: \(route.distanceTraveled, specifier: "%.2f") 미터")
                                .fontWeight(.bold)
                        }
                        
                        VStack {
                            Text("걸음수-더미")
                                .fontWeight(.bold)
                            Text("10,000")
                                .fontWeight(.bold)
                        }
                        
                        VStack {
                            Text("총 시간")
                                .fontWeight(.bold)
//                            Text("\(dummyData.totalTime)")
//                                .fontWeight(.bold)
                            Text("소요 시간: \(route.duration)")
                                .fontWeight(.bold)
                        }
                    }
                    
                    Text("테마")
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
                        .padding(.leading, -8)
                    }
                    
                    TagView()
                    
                    Text("사진")
                    
                    Button(action: {
                               self.showingImagePicker = true
                           }) {
                               Text("Select Image")
                           }
                           .sheet(isPresented: $showingImagePicker) {
                               ImagePicker(image: self.$inputImage)
                           }
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem()]) {
                            ForEach(1..<10) { index in
                                Rectangle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color.gray)
                                    .cornerRadius(10)
                                    .padding()
                            }
                        }
                        .padding(.leading, -8)
                    }
                }
                .padding()
                
                Spacer()
                
                
                
                Button(action: {
                    // 주소 변환 작업을 시작합니다.
                    LocationManager.changeToAddress(location: self.locationManager.changeToClLocation(latitude: self.locationManager.currentLocation?.latitude, longitude: self.locationManager.currentLocation?.longitude)) { address in
                        // 이미지 업로드 후 URL을 받아옵니다.
                        if let inputImage = self.inputImage {
                            self.uploadImage(inputImage) { result in
                                switch result {
                                case .success(let url):
                                    // 최종 Route 객체를 업데이트합니다.
                                    let updatedRoute = Route(
                                        title: self.title,
                                        coordinates: self.locationManager.tempCoordinates, // 기존에 전달받은 좌표 사용
                                        imageUrl: url.absoluteString,
                                        address: address,
                                        memo: self.memo,
                                        types: self.selectedTypes,
                                        duration: route.duration, // 기존에 전달받은 타이머 정보 사용
                                        distanceTraveled: route.distanceTraveled // 기존에 전달받은 이동 거리 사용
                                    )
                                    // Firestore에 Route 객체를 저장합니다.
                                    FireStoreManager.shared.addRoute(route: updatedRoute, documentName: self.title) { error in
                                        if let error = error {
                                            print("Error adding route: \(error)")
                                        } else {
                                            // Firestore에 저장이 성공하면, 현재 저장된 데이터를 초기화합니다.
                                            self.locationManager.resetData()
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                case .failure(let error):
                                    print("Image upload error: \(error)")
                                }
                            }
                        } else {
                            // 이미지가 선택되지 않았을 경우의 로직
                            self.saveRouteToFirestore(imageUrl: nil, address: address)
                            print("No image selected")
                        }
                    }
                }) {
                    Text("Complete")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.indigo)
                        .foregroundColor(Color.black)
                        .cornerRadius(30)
                }
                .alert(isPresented: $SaveAlertPresented) {
                    Alert(
                        title: Text(""),
                        message: Text("산책로가 저장되었습니다!"),
                        primaryButton: .default(Text("공유하기")),
                        secondaryButton: .default(Text("확인"))
                    )
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
                        primaryButton: .destructive(Text("삭제하기")),
                        secondaryButton: .default(Text("취소"))
                    )
                }
            )
        }
    }
    
    func loadImage() {
        // 이미지 선택 후 처리 로직
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image"])))
            return
        }
        
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
    
    func getCurrentDateTime() -> String {
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentDate)
        
        return dateString
    }
    
    func saveRouteToFirestore(imageUrl: String?, address: String) {
        let updatedRoute = Route(
            title: self.title,
            coordinates: route.coordinates,
            imageUrl: imageUrl,
            address: address,
            memo: self.memo,
            types: self.selectedTypes,
            duration: route.duration,
            distanceTraveled: route.distanceTraveled
        )
        // Firestore에 Route 객체를 저장합니다.
        FireStoreManager.shared.addRoute(route: updatedRoute, documentName: self.title) { error in
            if let error = error {
                print("Error adding route: \(error)")
            } else {
                // Firestore에 저장이 성공하면, 현재 저장된 데이터를 초기화합니다.
                self.locationManager.resetData()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//#Preview {
//    RecordCompleteView()
//}
