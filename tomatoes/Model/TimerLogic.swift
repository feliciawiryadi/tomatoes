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
    
    enum State {
        case idle
        case running
        case paused
    }
    
    @Published var state: State = .idle
    @Published var timeRemaining: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var endDate: Date?
    private var timerConnector: AnyCancellable?
    
    private var timerFinishedSubject = PassthroughSubject<Void, Never>()
    var timerFinished: AnyPublisher<Void, Never> {
        timerFinishedSubject.eraseToAnyPublisher()
    }
    
    func start() {
        guard state == .idle, duration > 0 else { return }
        endDate = Date().addingTimeInterval(duration)
        connectTimer()
        state = .running
    }
    
    func stop(reset: Bool = false) {
        if state == .running {
            disconnectTimer()
        }
        
        if reset {
            timeRemaining = duration
            endDate = nil
            state = .idle
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
    }
    
    private func connectTimer() {
        timerConnector = Timer.publish(every: 0.1, on: .main, in: .common)
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
