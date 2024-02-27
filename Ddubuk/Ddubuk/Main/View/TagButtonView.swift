//
//  TagButtonView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/27/24.
//

import SwiftUI

struct TagButtonView: View {
    var tag: Tags
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            isPressed.toggle()
        }) {
            VStack {
                Image(tag.imageName)
                    .resizable()
                    .frame(width: 60, height: 50)
                    .foregroundColor(Color.secondary)
                    .border(isPressed ? Color.green : Color.black, width: 3)
                    .cornerRadius(10)
                Text(tag.rawValue)
                    .font(.custom("NotoSansKR-Medium", size: 10))
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    TagSelectView(tagName: "NightView")
}
