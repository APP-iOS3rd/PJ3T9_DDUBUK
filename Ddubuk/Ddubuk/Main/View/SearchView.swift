import SwiftUI



struct SearchView: View {
    @ObservedObject var routes = FireStoreManager.shared
    @State private var title: String = ""
    @State private var isSearchDetailViewActive = false
    
    let tags: [Tags] = Tags.allCases
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading){
                        Text("테마별로 산책하고 싶을땐?")
                            .font(.custom("NotoSansKR-Bold", size: 24))
                        Text("DDUBUK")
                            .font(.custom("NotoSansKR-Bold", size: 24))
                    }
                    .padding()
                }
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        TextField("원하는 지역명이나 산책로를 입력해주세요.", text: $title)
                                .onTapGesture {
                                    isSearchDetailViewActive = true
                                }
                   }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.black)
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
                
                LazyVGrid(columns: [
                               GridItem(.flexible(), spacing: 10),
                               GridItem(.flexible(), spacing: 10),
                               GridItem(.flexible(), spacing: 10),
                               GridItem(.flexible(), spacing: 10)
                           ], spacing: 10) {
                               ForEach(tags, id: \.self) { tag in
                                               SearchTagView(name: tag.rawValue, ImageView: tag.imageName)
                                           }
                           }
                           .padding()
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("최근 산책길")
                        .font(.custom("NotoSansKR-Bold", size: 24))
                        .padding()
                        .padding(.bottom, -50)
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        MainListView()
                            .padding(.leading, -20)
                    }
                    .padding()
                }
                
                
                VStack(alignment: .leading) {
                    Text("새로운 산책길")
                        .font(.custom("NotoSansKR-Bold", size: 24))
                        .padding()
                        .padding(.bottom, -50)
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        MainListView()
                            .padding(.leading, -20)
                    }
                    .padding()
                }
            }
            .onAppear {
                routes.fetchRoutes()
            }
        }
        .padding()
//        .navigationBarHidden(true)
                    .background(
                        NavigationLink("", destination: SearchClickView(), isActive: $isSearchDetailViewActive)
                            .hidden()
                    )

        .onTapGesture {
            endEditing()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("MainColor").opacity(0.5), Color.white]), startPoint: .top, endPoint: .bottom))
    }
    
    private func tagImageName(for tag: Tags) -> String {
            switch tag {
            case .NightView:
                return "NightView"
            case .Day:
                return "Afternoon"
            // 나머지 태그에 대한 이미지 이름도 추가할 수 있습니다.
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
    SearchView()
}
