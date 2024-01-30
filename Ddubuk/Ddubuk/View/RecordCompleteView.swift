//
//  RecordCompleteView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/30/24.
//

import SwiftUI

struct RecordCompleteView: View {
    
    @State private var title: String = ""
    @State private var SaveAlertPresented: Bool = false
    @State private var WarningAlertPresented: Bool = false
    
    struct  Info {
        var Date: String
        var walkCount: Int
        var walkDistance: Double
        var totalTime: String
    }
    
    let dummyData: Info = Info(
        Date: "2024-01-30",
        walkCount: 10323,
        walkDistance: 2.4,
        totalTime: "1시간 20분"
    )
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                
                Rectangle()
                    .frame(width: 350, height: 350)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    Divider()
                        .frame(minHeight: 3)
                        .overlay(Color.black)
                    
                    HStack {
                        Text("날짜:")
                            .fontWeight(.bold)
                        Text("\(dummyData.Date)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("제목:")
                            .fontWeight(.bold)
                        TextField("제목을 입력해 주세요.", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack(spacing: 30) {
                        VStack {
                            Text("산책거리")
                                .fontWeight(.bold)
                            Text("\(dummyData.walkDistance)km")
                                .fontWeight(.bold)
                        }
                        
                        VStack {
                            Text("걸음수")
                                .fontWeight(.bold)
                            Text("\(dummyData.walkCount)")
                                .fontWeight(.bold)
                        }
                        
                        VStack {
                            Text("총 시간")
                                .fontWeight(.bold)
                            Text("\(dummyData.totalTime)")
                                .fontWeight(.bold)
                        }
                    }
                    
                    Text("테마")
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem()]) {
                            ForEach(1..<10) { index in
                                Rectangle()
                                    .frame(width: 50, height: 20)
                                    .foregroundColor(Color.gray)
                                    .cornerRadius(5)
                                    .padding()
                            }
                        }
                        .padding(.leading, -8)
                    }
                    
                    Text("사진")
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
                
                Button {
                    SaveAlertPresented = true
                } label: {
                    Text("저장 버튼")
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
}

#Preview {
    RecordCompleteView()
}
