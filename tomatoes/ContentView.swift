//
//  ContentView.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 20/7/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("text field here")
            }
            Spacer()
            HStack {
                HStack {
                    Button(action: {}) {
                        Text("25m")
                            .frame(width: 30)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("5m")
                            .frame(width: 30)
                    }
                }
                .frame(width: 100)
                
                Spacer()
                
                Button(action: {}) {
                    Text("start")
                        .frame(width: 50)
                }
                
            }
        }
        .padding()
        .frame(maxWidth: 300, maxHeight: 100)
//        .cornerRadius(100.0)
    }
        
}

#Preview {
    ContentView()
}
