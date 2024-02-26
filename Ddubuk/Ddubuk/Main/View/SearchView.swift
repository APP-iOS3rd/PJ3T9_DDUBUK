import SwiftUI
import FirebaseFirestore

struct SearchView: View {
    
    @ObservedObject var routes = FireStoreManager.shared
    @StateObject var locationManager = LocationManager()
    @State private var title: String = ""
    @State private var isSearchDetailViewActive = false

    let tags = ["야경", "강아지", "비오는날", "달리기", "조용한", "붐비는", "건강에 좋은", "자전거"]

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
                                   SearchTagView(name: tag)
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
//        .background(
//            NavigationLink("", destination: SearchClickView(searchResults: searchResults), isActive: $isSearchDetailViewActive)
//                .hidden()
//        )
        .onAppear {
            routes.fetchRoutes()
            locationManager.getCurrentLocation()
        }
        
        .onTapGesture {
            endEditing()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("MainColor").opacity(0.5), Color.white]), startPoint: .top, endPoint: .bottom))
    }
    
    

    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func performSearch() {
        let db = Firestore.firestore()
        db.collection("places").whereField("name", isEqualTo: title)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var results: [String] = []
                    for document in querySnapshot!.documents {
                        // 예제에서는 name 필드만 추출합니다.
                        if let name = document.data()["name"] as? String {
                            results.append(name)
                        }
                    }
                    // 검색 결과를 SearchClickView로 전달하기 위해 상태 업데이트
                    DispatchQueue.main.async {
//                        self.searchResults = results
                        self.isSearchDetailViewActive = true
                    }
                }
            }
    }
}

#Preview {
    SearchView()
}
