//
//  SearchTagView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/26/24.
//

import SwiftUI

struct SearchTagView: View {
    @State private var isPressed = false
    var name: String

    var body: some View {
        VStack {
            Button {
                isPressed.toggle()
            } label: {
                Rectangle()
                    .frame(width: 60,height: 50)
                    .foregroundColor(Color.secondary)
                    .overlay(
                            Text(name)
                           .font(.system(size: 16))
                           .fontWeight(.bold)
                           .foregroundColor(.black)
                       )
                    .border(isPressed ? Color.green : Color.clear, width: 4)
                    .cornerRadius(10)
            }
            
        }
    }
}

#Preview {
    SearchTagView(name:"야경")
}
