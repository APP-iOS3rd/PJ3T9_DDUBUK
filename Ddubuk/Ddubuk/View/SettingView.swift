//
//  SettingView.swift
//  MapDemo
//
//  Created by 박호건 on 1/23/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            List {
                Section {

                    NavigationLink(destination: PasswordChangeView()) {

                        Text("비밀번호 변경")
                    }
                }
                
                Section {
                    Text("프로필 수정")
                }
                
                Section {
                    Text("언어")
                    Text("기기 권한")
                }
                
                Section {
                    Text("로그아웃")
                    Text("탈퇴하기")
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
