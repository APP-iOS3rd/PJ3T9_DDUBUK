//
//  CustomButton.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/19.
//

import SwiftUI

struct CustomButton: View {
        var title: String
        var systemImage: String
        var color: Color
        var isDisabled: Bool
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: systemImage)
                        .font(.headline)
                    Text(title)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 22)
                .foregroundColor(.black)
                .background(isDisabled ? Color.gray : color)
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            .disabled(isDisabled)
        }
    }

//#Preview {
//    CustomButton()
//}
