//
//  SearchView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//

import SwiftUI

struct SearchView: View {
    @State private var title: String = ""
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    VStack(alignment: .leading, spacing: 2) {
                        TextField("산책하는 지역명을 검색해주세요", text: $title)
                            
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.black)
                    }

                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .overlay {
                    Capsule()
                        .stroke(lineWidth: 0.5)
                        .foregroundColor(.gray)
                        .shadow(color: .black.opacity(0.4), radius: 2)
                }
                .padding()
                
                Spacer()
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        MainListView()
                    }
                    .padding()
                }
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        MainListView()
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    SearchView()
}
