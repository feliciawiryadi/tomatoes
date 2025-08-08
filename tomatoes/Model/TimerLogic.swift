//
//  TimerLogic.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 21/7/2025.
//

// Heavily inspired by https://github.com/marlonjames71/CountdownTimerTutorial

import Foundation
import Combine

final class TimerLogic: ObservableObject {
    
    // represents the current state of the timer
    enum State {
        case idle // initial state, default state after previous timer is up/ reset
        case running
        case paused
    }
    
    // represents the current type of timer, decides the duration of the timer
    enum Mode {
        case inactive
        case focus
        case rest
    }
    
    @Published var state: State = .idle
    @Published var mode: Mode = .inactive
    
    // this is the only place to manually change the duration for each mode
    final var focusDuration: TimeInterval = 10
    final var restDuration: TimeInterval = 5
    @Published private(set) var timeRemaining: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0
    
    private var endDate: Date?
    private var timerConnector: AnyCancellable?
    private var notificationManager = NotificationManager()
    
    private var timerFinishedSubject = PassthroughSubject<Void, Never>()
    var timerFinished: AnyPublisher<Void, Never> {
        timerFinishedSubject.eraseToAnyPublisher()
    }
    
    // mainly used to update UI when user clicks on the mode but haven't started it yet
    func updateDuration() {
        switch mode {
            case .focus:
                duration = focusDuration
                timeRemaining = focusDuration
            case .rest:
                duration = restDuration
                timeRemaining = restDuration
            default:
                print("something else")
                return
        }
    }
    
    func start() {
        guard state == .idle, duration > 0 else { return }
        endDate = Date().addingTimeInterval(duration)
        connectTimer()
        state = .running
        Task {
            await notificationManager.scheduleNotification(time: endDate!)
        }
        
    }
    
    func stop(reset: Bool = false) {
        if state == .running {
            disconnectTimer()
            notificationManager.removeAllScheduledNotifications()
        }
        
        if reset {
            timeRemaining = duration
            endDate = nil
            state = .idle
            mode = .inactive
            print("Timer resetted")
        } else {
            state = .paused
            print("Timer paused")
        }
        
    }
    
    func resume() {
        guard state == .paused else { return }
        endDate = Date().addingTimeInterval(timeRemaining)
        connectTimer()
        state = .running
        Task {
            await notificationManager.scheduleNotification(time: endDate!)
        }
    }
    
    private func connectTimer() {
        timerConnector = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] currentDate in
                guard let self, let endDate, state == .running else { return }
                
                let timeRemaining = endDate.timeIntervalSince(currentDate)
                
                if timeRemaining > 0 {
                    self.timeRemaining = timeRemaining
                    print("Time remaining: \(timeRemaining)")
                } else {
                    stop(reset: true)
                    timerFinishedSubject.send()
                    print("Timer finished")
                }
     
                
            }
    }
    
    private func disconnectTimer() {
        timerConnector?.cancel()
        timerConnector = nil
        print("Timer disconnected")
    }
}
