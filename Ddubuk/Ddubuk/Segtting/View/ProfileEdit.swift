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
                TextEditor(text: $name)
                    .padding()
                    .frame(height: 40)
                    .border(Color.black)
            }
            
            HStack {
                Text("이메일")
                TextEditor(text: $email)
                    .padding()
                    .frame(height: 40)
                    .border(Color.black)
            }
            
            HStack {
                Text("소개")
                TextEditor(text: $introduce)
                    .padding()
                    .frame(height: 60)
                    .border(Color.black)
            }
            
            HStack {
                Text("인스타 링크")
                TextEditor(text: $instagramID)
                    .padding()
                    .frame(height: 40)
                    .border(Color.black)
            }
            
        }
        .padding()
    }
}

#Preview {
    ProfileEdit()
}

