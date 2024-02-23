//
//  StopwatchView.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/19.
//

import SwiftUI
import UIKit


class StopwatchViewViewModel: ObservableObject {
    
    static let shared = StopwatchViewViewModel()
    
    private init() {}
    
    @Published var isActive = false
    @Published var isPause = false
    @Published var isDone = true
    @Published var secondsElapsed = 0
    
    private var lastBackgroundTime: Date?
    private var timer: Timer?
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.secondsElapsed += 1
            }
        }
    }
    
     func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            
            self.timer = nil
        }
    }
    
//    init() {
//        setupLifecycleObserver()
//    }
//    
//    deinit {
//        cleanupLifecycleObserver()
//    }
    
    private func setupLifecycleObserver() {
        let center = NotificationCenter.default
        
        center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.pauseTimerIfNeeded()
        }
        
        center.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.resumeTimerIfNeeded()
        }
    }
    
    private func cleanupLifecycleObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func pauseTimerIfNeeded() {
        if isActive {
            lastBackgroundTime = Date()
            
            stopTimer()
        }
    }
    
    private func resumeTimerIfNeeded() {
        if !isActive { return }
        
        if let lastBackgroundTime = lastBackgroundTime {
            let timeInBackground = Date().timeIntervalSince(lastBackgroundTime)
            secondsElapsed += Int(timeInBackground)
            self.lastBackgroundTime = nil
        }
        
        startTimer()
    }
    
    func updateAppStatus(_ status: ScenePhase) {
        switch status {
        case .background:
            pauseTimerIfNeeded()
        case .active:
            resumeTimerIfNeeded()
        default:
            break
        }
    }
}

extension StopwatchViewViewModel {
    func activeStopWatch() {
        secondsElapsed = 0
        isActive = true
        isPause = false
        isDone = false
        startTimer()
        
    }
    
    func deactivateStopWatch() {
        isPause = true
        stopTimer()
    }
    
    func completeTask() {
        isActive = false
        isPause = false
        isDone = true
        stopTimer()
//        secondsElapsed = 0
        print("completeTask")
    }
    
    func toggleStopWatch() {
        if isPause {
            // 일시 정지 상태에서 호출되면 타이머를 재개합니다.
            resumeTimer()
        } else {
            // 타이머가 진행 중일 때 호출되면 타이머를 일시 정지합니다.
            pauseTimer()
        }
    }
    
    private func pauseTimer() {
        isPause = true
        stopTimer()
    }
    
    private func resumeTimer() {
        isPause = false
        startTimer()
    }
}

struct StopwatchView: View {
    
    @StateObject var viewModel = StopwatchViewViewModel.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            Stopwatch(secondsElapsed: viewModel.secondsElapsed)
            
            Spacer()
            
            VStack(spacing: 20) {
                if !viewModel.isActive {
                    CustomButton(title: "작업 시작", systemImage: "arrowtriangle.right.fill", color: .green, isDisabled: viewModel.isActive) {
                        viewModel.activeStopWatch()
                    }
                } else {
                    CustomButton(title: viewModel.isPause ? "작업 재개" : "작업 일시정지", systemImage: viewModel.isPause ? "play.fill" : "stop.fill", color: .red, isDisabled: !viewModel.isActive) {
                        viewModel.toggleStopWatch()
                    }
                }
                
                CustomButton(title: "작업 종료", systemImage: "stopwatch.fill", color: .blue, isDisabled: viewModel.isDone) {
                    viewModel.completeTask()
                }
            }
        }
        .padding(.top, 100)
        .padding(.bottom, 70)
        .onChange(of: scenePhase) {
            viewModel.updateAppStatus(scenePhase)
        }
    }
}

#Preview {
    StopwatchView()
}
