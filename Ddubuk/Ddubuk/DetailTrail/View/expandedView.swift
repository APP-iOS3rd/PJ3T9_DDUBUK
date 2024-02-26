//
//  expandedView.swift
//  Ddubuk
//
//  Created by 조민식 on 1/31/24.
import SwiftUI
import ExpandableText

struct expandedView: View {

    let text: String
    
    var body: some View {
        ExpandableText(text: text)
            .font(.custom("NotoSansKR-Medium", size: 14))
            .foregroundColor(.primary)//optional
            .lineLimit(2)//optional
            .expandButton(TextSet(text: "더보기", font: .custom("NotoSansKR-Bold", size: 16), color: .black))//optional
            .collapseButton(TextSet(text: "간략히", font: .custom("NotoSansKR-Bold", size: 16), color: .black))//optional
            .expandAnimation(.easeOut)//optional
            .frame(width: 300)
            .padding(.horizontal, 24)//optional
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.black), lineWidth: 1)
                    
            )
    }
}
