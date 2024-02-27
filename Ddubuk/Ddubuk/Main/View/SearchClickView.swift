//
//  SearchClickView.swift
//  Ddubuk
//
//  Created by 박호건 on 2/25/24.
//

import SwiftUI

enum Tags: String, CaseIterable {
    case NightView = "야경이 좋은"
    case Day = "낮에 걷기 좋은"
    case Dog = "강아지와 함께"
    case Child = "아이와 함께"
    case Trees = "나무가 많은"
    case Water = "물을 따라 걷는"
    case Hill = "언덕을 오르는"
    case Alley = "골목길을 걷는"
    
    var imageName: String {
            switch self {
            case .NightView:
                return "NightView"
            case .Day:
                return "Afternoon"
            case .Dog:
                return "Dog"
            case .Child:
                return "Child"
            case .Trees:
                return "Tree"
            case .Water:
                return "Water"
            case .Hill:
                return "Hill"
            case .Alley:
                return "City"
            }
        }
}

struct SearchClickView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var emptyText: String = ""
//    let tags = ["야경", "강아지", "비오는날", "달리기", "조용한", "붐비는", "건강에 좋은", "자전거"]
    
    let tags: [Tags] = Tags.allCases

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
                    .onTapGesture {
                        endEditing()
                    }
                    .overlay(
                        HStack {
                            Spacer()
                            if !emptyText.isEmpty {
                                Image(systemName: "x.circle.fill")
                                    .onTapGesture {
                                        emptyText = ""
                                    }
                                    .padding(.trailing, 25)
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
                               SearchTagView(name: tag.rawValue, ImageView: tagImageName(for: tag))
                                           }
                       }
                       .padding()
            
            Divider()
                .frame(height: 1)
                .background(.gray)
            SearchDetailView()
                .padding(.leading, -12)
            
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        .onTapGesture {
            endEditing()
        }
    }
    
    private func tagImageName(for tag: Tags) -> String {
            switch tag {
            case .NightView:
                return "NightView"
            case .Day:
                return "Afternoon"
            case .Dog:
                return "Dog"
            case .Child:
                return "Child"
            case .Trees:
                return "Tree"
            case .Water:
                return "Water"
            case .Hill:
                return "Hill"
            case .Alley:
                return "Alley"
            }
        }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    SearchClickView()
}
