import SwiftUI
import FirebaseFirestore

struct SearchView: View {
    
    @ObservedObject var routes = FireStoreManager.shared
    @StateObject var locationManager = LocationManager()
    @State private var title: String = ""
    @State private var isSearchDetailViewActive = false
    @State var searchResults: [String] = []
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    VStack(alignment: .leading, spacing: 2) {
                        TextField("산책하는 지역명을 검색해주세요", text: $title, onCommit: {
                            performSearch()
                            isSearchDetailViewActive = true
                        })
                   }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(Color.primary)
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
                        self.searchResults = results
                        self.isSearchDetailViewActive = true
                    }
                }
            }
    }
}

#Preview {
    SearchView()
}
