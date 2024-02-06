//
//  PasswordChangeView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/29/24.
//

import SwiftUI

struct PasswordChangeView: View {
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var repeatPassword: String = ""
    @State private var alertMessage: String?
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            Spacer()

            TextField("현재 비밀번호를 입력해주세요.", text: $currentPassword)
                .padding()

            TextField("새 비밀번호를 입력해주세요.", text: $newPassword)
                .padding()

            TextField("비밀번호를 다시 입력해주세요.", text: $repeatPassword)
                .padding()

            Spacer()

            Button {
                changePassword()
            } label: {
                Text("확인")
                    .padding()
                    .frame(width: 200)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("확인")))
            }

            Spacer()
        }
        .padding()
    }

    func changePassword() {
        if currentPassword.isEmpty || newPassword.isEmpty || repeatPassword.isEmpty {
            alertMessage = "모든 필드를 입력하세요."
            showAlert = true
        } else if newPassword != repeatPassword {
            alertMessage = "새 비밀번호가 일치하지 않습니다."
            showAlert = true
        } else {
            alertMessage = "비밀번호가 성공적으로 변경되었습니다."
            showAlert = true
        }
    }
}

#Preview {
    PasswordChangeView()
}
