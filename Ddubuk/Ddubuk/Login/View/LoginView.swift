////
////  LoginView.swift
////  Ddubuk
////
////  Created by 박호건 on 2/17/24.
////
//
//import SwiftUI
//
//struct LoginView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @StateObject private var viewModel = AuthViewModel()
//    @State private var signInSuccess = false
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
//                InputView(text: $password, title: "비밀번호", placeholder: "비밀번호를 입력해주세요.", isSecureField: true)
//            }
//            .padding()
//            .padding(.top, 12)
//            
//            Button {
//                viewModel.signIn(email: email, password: password) { result in
//                    switch result {
//                    case .success(let user):
//                        // 로그인 성공
//                        print("로그인 성공: \(user)")
//                        signInSuccess = true
//                    case .failure(let error):
//                        // 로그인 실패
//                        print("로그인 실패: \(error)")
//                    }
//                }
//            } label: {
//                HStack {
//                    Text("SIGN IN")
//                        .fontWeight(.semibold)
//                    Image(systemName: "arrow.right")
//                }
//                .foregroundColor(.white)
//                .frame(width: 370, height: 40)
//            }
//            .background(Color.blue)
//            .cornerRadius(10)
//
//            
//            Spacer()
//            
//            NavigationLink(destination: SettingView(), isActive: $signInSuccess) {
//                            EmptyView()
//                        }
//            
//            NavigationLink(destination: SignUpView()
//                .navigationBarBackButtonHidden()) {
//                HStack {
//                    Text("아이디가 없으신가요?")
//                    Text("가입")
//                        .fontWeight(.bold)
//                }
//                .foregroundColor(.blue)
//            }
//            Spacer()
//        }
//        .padding(.vertical, 32)
//    }
//}
//
//#Preview {
//    LoginView()
//}
