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
    @ObservedObject private var authViewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 32) {
            Text("비밀번호 변경")
            
            Spacer()

            SecureField("현재 비밀번호를 입력해주세요.", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("새 비밀번호를 입력해주세요.", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("비밀번호를 다시 입력해주세요.", text: $repeatPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Spacer()

            Button {
                authViewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword) { result in
                    switch result {
                    case .success:
                        alertMessage = "비밀번호가 성공적으로 변경되었습니다."
                    case let .failure(error):
                        if currentPassword.isEmpty || newPassword.isEmpty || repeatPassword.isEmpty {
                            alertMessage = "모든 필드를 입력하세요."
                        } else if newPassword != repeatPassword {
                            alertMessage = "새 비밀번호가 일치하지 않습니다."
                        } else if currentPassword == newPassword {
                            alertMessage = "새 비밀번호가 이전 비밀번호랑 일치합니다."
                        } else {
                            // 성공적으로 변경되었을 때
                            alertMessage = "비밀번호가 성공적으로 변경되었습니다."
                        }
                        showAlert = true
                    }
                }
                        } label: {
                Text("비밀번호 변경")
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

}

#Preview {
    PasswordChangeView()
}
