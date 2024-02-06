////
////  RecordCompletionView.swift
////  Ddubuk
////
////  Created by lkh on 1/22/24.
////
//
//import SwiftUI
//
//// MARK: - RecordCompletionView
//struct RecordCompletionView: View {
//    // MARK: Object
//    @EnvironmentObject var viewModel: RecordViewModel
//    
//    @ObservedObject var locationManager: LocationManager
//    
//    // MARK: State
//    @State private var titleText: String = ""
//    @FocusState private var focusField: Bool
//    
//    // MARK: Binding
//    @Binding var isBack:Bool
//    
//    // MARK: - View
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .center, spacing: 0) {
//                RecordMap(
//                    userLocations: viewModel.userLocations,
//                    isRecording: viewModel.isRecording,
//                    timerState: viewModel.timerState
//                )
//                .frame(height: 300)
//                    
//                Divider()
//
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("날짜: \(getCurrentDateTime())")
//                        
//                    HStack(alignment: .center, spacing: 0) {
//                        Text("제목: ")
//                            .frame(height: 50)
//                        
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 20, style: .circular)
//                                .foregroundColor(Color.gray.opacity(0.1))
//                                .frame(height: 50)
//                            
//                            TextField("", text: $titleText)
//                                .focused($focusField)
//                                .textInputAutocapitalization(.never)
//                                .disableAutocorrection(true)
//                        }
//                    }
//                }
//                .padding()
//                
//
//                HStack(alignment: .center, spacing: 10) {
//                    VStack(alignment: .center, spacing: 10) {
//                        Text("산책거리")
//                        Text(viewModel.recordingMeter)
//                            .bold()
//                            //.foregroundColor(.black)
//                    }
//                    
//                    Spacer()
//                    
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("시간")
//                        Text(viewModel.recordingTime.asTimestamp)
//                            .bold()
//                            //.foregroundColor(.black)
//                    }
//                    
//                    Spacer()
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//                
//            }
//        }
//        
//        // MARK: - 뒤로가기
//        .toolbar {
//            // Leading
//            ToolbarItem(placement: .navigationBarLeading) {
//                HStack(alignment: .center, spacing: 0) {
//                    Button(action: {
//                        isBack.toggle()
//                    }, label: {
//                        Image(systemName: "trash")
//                            .resizable()
//                            .foregroundColor(.secondary)
//                    })
//                    
//                    Spacer()
//                } // HStack
//                .padding(.horizontal)
//            } // ToolbarItem
//        } // toolbar
//    } // body
//    
//    // MARK: - getCurrentDateTime
//    // 오늘 날짜 반환
//    func getCurrentDateTime() -> String {
//        let currentDate = Date()
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateString = formatter.string(from: currentDate)
//        
//        return dateString
//    }
//}
