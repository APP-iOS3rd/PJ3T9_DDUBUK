////
////  RecordCompleteView.swift
////  Ddubuk
////
////  Created by 김재완 on 2024/02/02.
////
//
//import SwiftUI
//import FirebaseStorage
//
//struct RecordCompleteView1: View {
//    @ObservedObject var locationManager: LocationManager
//    @State var title = ""
//    @State var memo: String = ""
//    @State private var showingImagePicker = false
//    @State private var inputImage: UIImage?
//    @State private var selectedTypes: [WalkingType] = []
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    let storage = Storage.storage()
//    
//    var body: some View {
//        VStack {
//            TextField("제목을 입력해 주세요", text: $title)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            TextField("Memo", text: $memo)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            ForEach(WalkingType.allCases, id: \.self) { type in
//                Toggle(isOn: Binding(
//                    get: { self.selectedTypes.contains(type) },
//                    set: { isSelected in
//                        if isSelected {
//                            self.selectedTypes.append(type)
//                        } else {
//                            self.selectedTypes.removeAll { $0 == type }
//                        }
//                    }
//                )) {
//                    Text(type.rawValue)
//                }
//            }
//            
//            Button(action: {
//                self.showingImagePicker = true
//            }) {
//                Text("Select Image")
//            }
//            
//            Button(action: {
//                // 주소 변환 작업을 시작합니다.
//                LocationManager.changeToAddress(location: self.locationManager.changeToClLocation(latitude: self.locationManager.currentLocation?.latitude, longitude: self.locationManager.currentLocation?.longitude)) { address in
//                    
//                    // 주소 변환 작업이 완료되면, 메인 스레드에서 Route 객체를 생성하고 Firestore에 저장합니다.
//                    DispatchQueue.main.async {
//                        // 이미지 업로드 후 URL을 받아옵니다.
//                        if let inputImage = self.inputImage {
//                            self.uploadImage(inputImage) { result in
//                                switch result {
//                                case .success(let url):
//                                    // 이미지 URL을 포함하여 Route 객체를 생성합니다.
//                                    let route = Route(
//                                        title: self.title,
//                                        coordinates: self.locationManager.tempCoordinates,
//                                        imageUrl: url.absoluteString,
//                                        address: address,
//                                        memo: self.memo,
//                                        types: self.selectedTypes,
//                                        duration: self.locationManager.tempDurationString,
//                                        // 임시 저장된 이동 거리를 포함합니다.
//                                        distanceTraveled: self.locationManager.tempDistanceTraveled
//                                    )
//                                    // Firestore에 Route 객체를 저장합니다.
//                                    FireStoreManager.shared.addRoute(route: route, documentName: self.title) { error in
//                                        if let error = error {
//                                            print("Error adding route: \(error)")
//                                        } else {
//                                            // Firestore에 저장이 성공하면, 현재 저장된 데이터를 초기화합니다.
//                                            self.locationManager.resetData()
//                                            self.presentationMode.wrappedValue.dismiss()
//                                        }
//                                    }
//                                case .failure(let error):
//                                    print("Image upload error: \(error)")
//                                }
//                            }
//                        } else {
//                            // 이미지가 선택되지 않았을 경우의 로직
//                            print("No image selected")
//                        }
//                    }
//                }
//            }) {
//                Text("Complete")
//            }
//        }
//        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//            ImagePicker(image: self.$inputImage)
//        }
//    }
//    
//    func loadImage() {
//        // 이미지 선택 후 처리 로직
//    }
//    
//    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image"])))
//            return
//        }
//        
//        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
//        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                storageRef.downloadURL { (url, error) in
//                    if let error = error {
//                        completion(.failure(error))
//                    } else if let url = url {
//                        completion(.success(url))
//                    }
//                }
//            }
//        }
//    }
//}
////}
////
////#Preview {
////    RecordCompleteView()
////}
