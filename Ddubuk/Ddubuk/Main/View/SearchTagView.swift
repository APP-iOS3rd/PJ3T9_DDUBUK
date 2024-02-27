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
    var ImageView: String

    var body: some View {
        VStack {
            Button {
                isPressed.toggle()
            } label: {
                Image(ImageView)
                    .resizable()
                    .frame(width: 60,height: 50)
                    .foregroundColor(Color.secondary)
                    .border(isPressed ? Color.green : Color.clear, width: 4)
                    .cornerRadius(10)
            }
            Text(name)
                .font(.custom("NotoSansKR-Medium", size: 10))
           .foregroundColor(.black)
        }
    }
}

#Preview {
    SearchTagView(name:"야경", ImageView: "NightView")
}
