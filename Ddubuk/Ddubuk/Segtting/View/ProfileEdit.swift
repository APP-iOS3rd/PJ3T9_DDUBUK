//
//  ProfileEdit.swift
//  Ddubuk
//
//  Created by 박호건 on 2/7/24.
//

import SwiftUI

struct ProfileEdit: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var introduce: String = ""
    @State private var instagramID: String = ""
    
    @State var showImagePicker = false
    @State var selectedUIImage: UIImage?
    @State var image: Image?
        
        func loadImage() {
            guard let selectedImage = selectedUIImage else { return }
            image = Image(uiImage: selectedImage)
        }
    
    var body: some View {
        
        Spacer()
        
        VStack {
            if let image = image {
                image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 120, height: 120)
            } else {
                Image(systemName: "circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 120, height: 120)
            }
               
                       
            Button {
                showImagePicker.toggle()
            } label: {
                Text("프로필 사진 변경")
            }
            .sheet(isPresented: $showImagePicker, onDismiss: {
                loadImage()
            }) {
                ImagePicker(image: $selectedUIImage)
            }
        }
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("이름")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                TextEditor(text: $name)
                    .padding()
                    .foregroundColor(Color.primary)
                    .font(.system(size: 18))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .border(Color.primary, width: 1)
            }
            
//            HStack {
//                Text("이메일")
//                    .fontWeight(.bold)
//                    .font(.system(size: 20))
//                TextEditor(text: $email)
//                    .padding()
//                    .foregroundColor(Color.primary)
//                    .font(.system(size: 20))
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
//                    .border(Color.primary, width: 1)
//            }
//            
//            HStack {
//                Text("소개")
//                    .fontWeight(.bold)
//                    .font(.system(size: 20))
//                TextEditor(text: $introduce)
//                    .padding()
//                    .foregroundColor(Color.primary)
//                    .font(.system(size: 15))
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
//                    .border(Color.primary, width: 1)
//            }
//            
//            HStack {
//                Text("인스타 링크")
//                    .fontWeight(.bold)
//                    .font(.system(size: 20))
//                TextEditor(text: $instagramID)
//                    .padding()
//                    .foregroundColor(Color.primary)
//                    .font(.system(size: 18))
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
//                    .border(Color.primary, width: 1)
//            }
        }
        .padding()
        
        Spacer()

        Button {
            
        } label: {
            Text("저장버튼")
                .padding()
                .foregroundColor(Color.primary)
                .background(Color.green)
                .cornerRadius(10)
        }
        
    }
}

#Preview {
    ProfileEdit()
}

