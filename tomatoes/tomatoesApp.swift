//
//  tomatoesApp.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 20/7/2025.
//

import SwiftUI

@main
struct tomatoesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            Text("Settings or main app window")
        }
    }
}
