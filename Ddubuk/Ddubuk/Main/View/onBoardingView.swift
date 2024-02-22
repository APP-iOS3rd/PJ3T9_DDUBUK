//
//  onBoardingView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/19/24.
//

import SwiftUI

struct onBoardingView: View {
    @State private var showingLoginView = false
    let exampleRoute = Route(title: "예시", coordinates: [], imageUrl: nil, address: nil, memo: "", types: [], duration: "0", distanceTraveled: 0.0)
    var viewModel = RecordViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("뚜벅에 오신 걸 환영합니다.")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // 여기에 환영 이미지 또는 다른 콘텐츠 추가 가능
                
                Spacer()
                
                HStack{
                    NavigationLink(destination: LoginView()) {
                        Text("로그인하러 가기")
                            .padding()
                            .foregroundColor(.blue)
                    }
                    
                    
                    
                    NavigationLink(destination: Main(route: exampleRoute)
                        .environmentObject(viewModel)
                        .navigationBarBackButtonHidden(true)){
                        Text("게스트로 시작하기")
                            .padding()
                            .foregroundColor(.green)
                    }
                    
                }
                .padding()
                
            }
            
        }
    }
}

#Preview {
    onBoardingView()
}
