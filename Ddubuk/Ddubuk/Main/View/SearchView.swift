import SwiftUI

struct SearchView: View {
    @ObservedObject var routes = FireStoreManager.shared
    @State private var title: String = ""
    @State private var isSearchDetailViewActive = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    VStack(alignment: .leading, spacing: 2) {
                        TextField("산책하는 지역명을 검색해주세요", text: $title)
                                .onTapGesture {
                                    isSearchDetailViewActive = true
                                    endEditing()
                                }
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
    }

    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchView()
}
