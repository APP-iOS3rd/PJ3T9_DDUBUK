////
////  InputView.swift
////  Ddubuk
////
////  Created by 박호건 on 2/17/24.
////
//
//import SwiftUI
//
//struct InputView: View {
//    
//    @Binding var text: String
//    let title: String
//    let placeholder: String
//    var isSecureField = false
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .foregroundColor(Color.primary)
//                .fontWeight(.semibold)
//                .font(.system(size: 30))
//            
//            if isSecureField {
//                SecureField(placeholder, text: $text)
//                    .font(.system(size: 14))
//            }else {
//                TextField(placeholder, text: $text)
//                    .font(.system(size: 14))
//            }
//            
//            Divider()
//        }
//    }
//}
//
//#Preview {
//    InputView(text: .constant(""), title: "Email Address", placeholder: "name@Example.com")
//}
