//
//  TimerViewModel.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/16.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var elapsedTime: Int = 0
    @Published var timerString: String = "00:00"
    
    private var timer: AnyCancellable?
    
    func startTimer() {
        elapsedTime = self.elapsedTime
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.elapsedTime += 1
                self?.timerString = self?.formatTime(self?.elapsedTime ?? 0) ?? "00:00"
            }
    }
    
    func resetData() {
            stopTimer()
            elapsedTime = 0
            timerString = "00:00"
        }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
   func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
