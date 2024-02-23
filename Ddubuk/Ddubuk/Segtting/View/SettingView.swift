//
//  SettingView.swift
//  MapDemo
//
//  Created by 박호건 on 1/23/24.
//

import SwiftUI

struct SettingView: View {
    @State private var alertInquiry = false
    @State private var alertDelete = false
    @State private var alertLogout = false
    @State private var logout = false
    @ObservedObject var authViewModel = AuthViewModel() // AuthViewModel 추가
    @State private var alertMessage = ""

    
    private func openAppSettings() {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    
    private func deleteAccount() {
            authViewModel.deleteAccount { result in
                switch result {
                case .success:
                    alertDelete = true
                    alertMessage = "계정이 성공적으로 삭제되었습니다."
                case let .failure(error):
                    alertDelete = true
                    alertMessage = "계정 삭제 실패: \(error.localizedDescription)"
                }
            }
        }
    
    var body: some View {
        List {
            Section(header: Text("프로필").font(.headline).padding(.leading, -10)) {
                NavigationLink(destination: ProfileEdit()) {
                    Text("프로필 수정")
                }
                
                NavigationLink(destination: LoginView()) {
                    Text("로그인테스트")
                }
            }

            Section(header: Text("계정").font(.headline).padding(.leading, -10)) {
                NavigationLink(destination: PasswordChangeView()) {
                    Text("비밀번호 변경")
                }
                
                Button {
                    logout.toggle()
                } label: {
                    Text("로그아웃")
                        .foregroundColor(Color.primary)
                }
                .alert(isPresented: $logout) {
                    Alert(
                        title: Text("로그아웃"),
                        message: Text("정말 로그아웃 하시겠습니까?"),
                        primaryButton: .destructive(Text("네")) {
                            authViewModel.signOut { result in
                                                        switch result {
                                                        case .success:
                                                            print("로그아웃 성공")
                                                        case let .failure(error):
                                                            print("로그아웃 실패: \(error.localizedDescription)")
                                                        }
                                                    }
                            print("logout")
                        },
                        secondaryButton: .cancel(Text("아니요"))
                    )
                }

            }

            Section(header: Text("내 앱 및 미디어").font(.headline).padding(.leading, -10)) {
                    Text("언어")
                Button {
                    openAppSettings()
                } label: {
                    Text("기기권한")
                        .foregroundColor(Color.primary)
                }

            }

            Section(header: Text("도움").font(.headline).padding(.leading, -10)) {
                Button {
                    alertInquiry.toggle()
                } label: {
                    Text("문의하기")
                        .foregroundColor(Color.primary)
                }
                .alert(isPresented: $alertInquiry) {
                    Alert(
                        title: Text("문의하기"),
                        message: Text("DDUBUK@naver.com으로 연락주세요!")
                    )
                }

                Button("계정 삭제") {
                    deleteAccount()
                }
                .foregroundColor(.red)
                .alert(isPresented: $alertDelete) {
                    Alert(
                        title: Text("계정 삭제"),
                        message: Text(alertMessage),
                        primaryButton: .default(Text("확인")) {
                            // 계정 삭제 후에 수행할 작업을 추가할 수 있습니다.
                        },
                        secondaryButton: .cancel(Text("아니요"))
                    )
                    
                }
                        
            }
        }
    }
}

#Preview {
    SettingView()
}
