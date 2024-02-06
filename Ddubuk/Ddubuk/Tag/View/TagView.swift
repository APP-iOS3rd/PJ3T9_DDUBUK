//
//  TagView.swift
//  Ddubuk
//
//  Created by 조민식 on 2/2/24.
//

import SwiftUI

struct TagView: View {
    @State private var tags: [String] = [
        "야경이 좋은", "낮에 걷기 좋은", "아이와 함께", "강아지와 함께", "나무가 많은", "물 따라 걷는", "난이도가 있는"
    ]
    @State private var seletedTags: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(seletedTags, id: \.self) { tag in
                        TagView(tag, .pink, "checkmark")
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    seletedTags.removeAll(where: { $0 == tag})
                                }
                            }
                    }
                }
                .padding(.horizontal, 15)
                .frame(height: 35)
                .padding(.vertical, 15)
            }
            .background(.white)
            
            ScrollView(.vertical) {
                TagLayout(alignment: .center, spacing: 10) {
                    ForEach(tags.filter { !seletedTags.contains($0) }, id: \.self) { tag in
                        TagView(tag, .blue, "plus")
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    seletedTags.insert(tag, at: 0)
                                }
                            }
                    }
                }
                .padding(15)
            }
            .background(.black.opacity(0.05))
          
        }
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    func TagView(_ tag: String, _ color: Color, _ icon: String) -> some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)
            
            Image(systemName: icon)
        }
        .frame(height: 35)
        .foregroundStyle(.white)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(color.gradient)
        }
    }
}

#Preview {
    TagView()
}
