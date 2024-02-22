//
//  Stopwatch.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/19.
//

import SwiftUI

struct Stopwatch: View {
    var secondsElapsed: Int

    func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    var body: some View {
        Text(formatTime(secondsElapsed))
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}



//#Preview {
//    Stopwatch()
//}
