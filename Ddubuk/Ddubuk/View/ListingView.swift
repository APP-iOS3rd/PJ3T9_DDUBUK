//
//  ListingView.swift
//  Ddubuk
//
//  Created by 박호건 on 1/22/24.
//

import SwiftUI

struct ListingView: View {
    
    @State private var showActionSheet = false

    var route: String
    var showEllipsis: Bool = true

    var images = [
        "images-1",
        "images-2",
        "images-3",
        "images-4",
    ]

    struct WalkData {
        var title: String
        var date: String
        var length: String
        var duration: String
        var steps: String
    }

    let dummyData: WalkData = WalkData(
        title: "길지만 이것은 바로 산책로 제목입니다.",
        date: "2024년 2월 12일",
        length: "823m",
        duration: "23분",
        steps: "5930걸음"
    )

    var body: some View {
        VStack(spacing: 10) {
            TabView {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .tabViewStyle(.page)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(dummyData.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)
                        Text(dummyData.date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if showEllipsis {
                        Button(action: {
                            showActionSheet = true
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .actionSheet(isPresented: $showActionSheet) {
                            ActionSheet(
                                title: Text(""),
                                buttons: [
                                    .destructive(Text("삭제")) {
                        
                                    },
                                    .cancel()
                                ]
                            )
                        }
                    }
                }

                HStack {
                    VStack {
                        Text("코스 길이")
                        Text(dummyData.length)
                    }

                    Divider()
                        .frame(height: 50)
                        .background(.black)

                    VStack {
                        Text("걸은 시간")
                        Text(dummyData.duration)
                    }

                    Divider()
                        .frame(height: 50)
                        .background(.black)

                    VStack {
                        Text("걸음 수")
                        Text(dummyData.steps)
                    }
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding()
    }
}

#Preview {
    ListingView(route: "Route A", showEllipsis: false) // ExploreView에서는 ellipsis 표시
}
