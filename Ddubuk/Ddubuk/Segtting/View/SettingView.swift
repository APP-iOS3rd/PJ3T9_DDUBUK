//
//  SettingView.swift
//  MapDemo
//
//  Created by 박호건 on 1/23/24.
//

import SwiftUI

struct SettingView: View {
    @State private var showAlert = false
    @State private var logout = false
    
    private func openAppSettings() {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    
    
    var body: some View {
        List {
            Section(header: Text("프로필").font(.headline).padding(.leading, -10)) {
                NavigationLink(destination: ProfileEdit()) {
                    Text("프로필 수정")
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
                            // 로그아웃 로직
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
                    showAlert.toggle()
                } label: {
                    Text("문의하기")
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("문의하기"),
                        message: Text("DDUBUK@naver.com으로 연락주세요!")
                    )
                }

                Text("탈퇴하기")
                    .foregroundColor(Color.red)
            }
        }
    }
}

#Preview {
    SettingView()
}
