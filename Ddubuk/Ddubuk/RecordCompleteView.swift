//
//  RecordCompleteView.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/29.
//

import SwiftUI

struct RecordCompleteView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var documentName = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Document Name", text: $documentName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                locationManager.updateInformation(info: documentName)
                locationManager.stopTimer()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Complete")
            }
        }
    }
}
//
//#Preview {
//    RecordCompleteView()
//}
