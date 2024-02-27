//
//  TagSelectView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/27/24.
//
import SwiftUI

struct TagSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    var tagName: String

    @State private var selectedTags: [Tags] = Tags.allCases

    var body: some View {
        VStack {
            Divider()
                .frame(height: 3)
                .foregroundColor(.gray)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], spacing: 10) {
                ForEach(selectedTags, id: \.self) { tag in
                                    TagButtonView(tag: tag)
                                }
            }
            .padding()
            Divider()
                .frame(height: 3)
                .foregroundColor(.gray)
            
//            SearchDetailView()
            
            Spacer()
        }
        .navigationBarTitle("테마선택")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            .frame(width: 44, height: 44)
        })
    }
}

#Preview {
    TagSelectView(tagName: "NightView")
}
