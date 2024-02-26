////
////  SignUpView.swift
////  Ddubuk
////
////  Created by 박호건 on 2/17/24.
////
//
//import SwiftUI
//
//struct SignUpView: View {
//    @State private var email = ""
//    @State private var nickName = ""
//    @State private var password = ""
//    @State private var confirmPassword = ""
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var authViewModel = AuthViewModel()
//    var body: some View {
//        VStack{
//            Image(systemName: "lock.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)
//                .padding(.vertical, 32)
//            
//            VStack(spacing: 12) {
//                InputView(text: $email, title: "이메일", placeholder: "name@example.com")
//                    .autocapitalization(.none)
//                
//                InputView(text: $nickName, title: "이름", placeholder: "이름을 입력하세요.")
//                    
//                
//                InputView(text: $password, title: "비밀번호", placeholder: "비밀번호를 입력하세요", isSecureField: true)
//                
//                InputView(text: $confirmPassword, title: "비밀번호 확인", placeholder: "다시 비밀번호를 입력해주세요.", isSecureField: true)
//                    
//            }
//            .padding()
//            .padding(.top, -30)
//            
//            Button {
//                authViewModel.signUp(email: email, password: password) { result in
//                    switch result {
//                    case .success:
//                        print("회원가입 성공")
//                    case let .failure(error):
//                        print("회원가입 실패: \(error.localizedDescription)")
//                    }
//                }
//            } label: {
//                HStack {
//                    Text("SIGN UP")
//                        .fontWeight(.semibold)
//                    Image(systemName: "arrow.right")
//                }
//                .foregroundColor(.white)
//                .frame(width: 370, height: 40)
//            }
//            .background(Color.blue)
//            .cornerRadius(10)
//            
//            Spacer()
//            
//            Button {
//                dismiss()
//            } label: {
//                HStack {
//                    Text("아이디가 있으신가요?")
//                    Text("로그인")
//                        .fontWeight(.bold)
//                }
//                .foregroundColor(.blue)
//            }
//
//        }
//        
//    }
//}
//
//#Preview {
//    SignUpView()
//}
