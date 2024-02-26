//
//  SearchClickView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/25/24.
//

import SwiftUI

struct SearchClickView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var emptyText: String = ""
    let tags = ["야경", "강아지", "비오는날", "달리기", "조용한", "붐비는", "건강에 좋은", "자전거"]

    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        
                }
                
                TextField("", text: $emptyText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        HStack {
                            Spacer()
                            if !emptyText.isEmpty {
                                Image(systemName: "x.circle.fill")
                                    .onTapGesture {
                                        emptyText = ""
                                    }
                                    .padding(.trailing, 8)
                            }
                        }
                    )
                    .shadow(radius: 2)
                
                
            }
            Divider()
                .frame(height: 1)
                .background(.black)
            
            LazyVGrid(columns: [
                           GridItem(.flexible(), spacing: 10),
                           GridItem(.flexible(), spacing: 10),
                           GridItem(.flexible(), spacing: 10),
                           GridItem(.flexible(), spacing: 10)
                       ], spacing: 10) {
                           ForEach(tags, id: \.self) { tag in
                               SearchTagView(name: tag)
                           }
                       }
                       .padding()
            
            Divider()
                .frame(height: 1)
                .background(.black)
            SearchDetailView()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding()
    }
}


#Preview {
    SearchClickView()
}
