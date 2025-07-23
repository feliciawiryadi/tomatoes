//
//  ContentView.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 20/7/2025.
//

import SwiftUI

struct ContentView: View {
    
    init(timerLogic: TimerLogic) {
        self.timerLogic = timerLogic
    }
    
    @ObservedObject var timerLogic: TimerLogic
    
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(DateComponentsFormatter().string(from: timerLogic.timeRemaining)!)
                    .font(Font.system(size: 25, weight: .bold))
            }
            Spacer()
            HStack {
                HStack {
                    Button(action: {
                        timerLogic.duration = 10
                        timerLogic.timeRemaining = 10
                        timerLogic.state = .idle
                    }) {
                        Text("25m")
                            .frame(width: 30)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        timerLogic.duration = 5
                        timerLogic.timeRemaining = 5
                        timerLogic.state = .idle

                    }) {
                        Text("5m")
                            .frame(width: 30)
                    }
                }
                .frame(width: 100)
                
                Spacer()
                
                
                switch timerLogic.state {
                    case .running:
                        Button(action: {
                        timerLogic.stop()
                    }) {
                        Text("stop")
                            .frame(width: 50)
                    }
                case .idle:
                    Button(action: {
                        timerLogic.start()
                    }) {
                        Text("start")
                            .frame(width: 50)
                    }
                    
                case .paused:
                    Button(action: {
                        timerLogic.resume()
                    }) {
                        Text("resume")
                            .frame(width: 50)
                    }
                    
                }
                
            }
        }
        .padding()
        .frame(maxWidth: 300, maxHeight: 100)
    }
        
}

#Preview {
    ContentView(timerLogic: TimerLogic())
}
