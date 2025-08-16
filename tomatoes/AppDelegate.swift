//
//  AppDelegate.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 20/7/2025.
//

import AppKit
import SwiftUI
import Cocoa
import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var statusBarItem: NSStatusItem?
    var window: NSWindow?
    var timerLogic: TimerLogic = TimerLogic()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusBarItem?.button {
            button.action = #selector(statusBarButtonClicked(_:))
            button.target = self
            button.image = NSImage(named: NSImage.Name("timelapse"))!
//            button.title = DateComponentsFormatter().string(from: TimerLogic().timeRemaining)!
            // this was an attempt to show the remaining seconds on the menu bar
        }
        
        UNUserNotificationCenter.current().delegate = self
        NotificationManager().requestAuthorisationForNotifications()
        registerCategories()
        
    }
    
    func registerCategories() {
        let startFocusAction = UNNotificationAction(identifier: "startFocusAction", title: "start focus", options: [])
        let startRestAction = UNNotificationAction(identifier: "startRestAction", title: "start rest", options: [])
        let inactiveAction = UNNotificationAction(identifier: "inactiveAction", title: "stop session", options: [])

        let focusModeCategory = UNNotificationCategory(identifier: "focusModeCategory", actions: [startRestAction, inactiveAction], intentIdentifiers: [], options: .customDismissAction)
        let restModeCategory = UNNotificationCategory(identifier: "restModeCategory", actions: [startFocusAction, inactiveAction], intentIdentifiers: [], options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([focusModeCategory, restModeCategory])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
//        willPresent notification: UNNotification,
        didReceive response: UNNotificationResponse,
//        notification: UNNotification,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        switch response.actionIdentifier {
            
        case "startFocusAction":
            timerLogic.mode = .focus
            timerLogic.updateDuration()
            timerLogic.start()
            print("start focus action clicked")
        case "startRestAction":
            timerLogic.mode = .rest
            timerLogic.updateDuration()
            timerLogic.start()
            print("start rest action clicked")
        default:
            print("inactive")
        }
//        completionHandler([.sound, .banner])
        completionHandler()
    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        
        // set the window width and height
        let windowWidth: CGFloat = 300
        let windowHeight: CGFloat = 100
        // center the window under the cursor
        let mouseLocation = NSEvent.mouseLocation
        let screenHeight = NSScreen.main?.frame.height ?? 0
        let windowX = mouseLocation.x - (windowWidth / 2)
        let windowY = screenHeight - getMenuBarHeight()! - (windowHeight/2)
        // construct the window
        window = getOrBuildWindow(
            size: NSRect(
                x: windowX,
                y: windowY,
                width: windowWidth,
                height: windowHeight)
        )
        
        toggleWindowVisibility(
            location: NSPoint(x:windowX, y: windowY)
        )
    }
    
    class KeyWindow: NSWindow {
        override var canBecomeKey: Bool {
            return true
        }
        
        override var canBecomeMain: Bool {
            return true
        }
    }
    
    @objc func getOrBuildWindow(size: NSRect) -> NSWindow {
        if window != nil {
            return window.unsafelyUnwrapped
        }
        
        window = KeyWindow(
            contentRect: size,
            styleMask: [], // originally the .borderless one
            backing: .buffered,
            defer: false
        )
        
        window!.contentView = NSHostingView(rootView: ContentView(timerLogic: timerLogic))
        window!.isReleasedWhenClosed = false
        window!.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window!.level = .floating
        
        return window.unsafelyUnwrapped
    }
    
    func toggleWindowVisibility(location: NSPoint) {
        if window == nil {
            return
        }
        
        if window!.isVisible {
            window!.orderOut(nil)
        } else {
            window!.makeKeyAndOrderFront(nil)
            window!.setFrameOrigin(location)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func getMenuBarHeight() -> CGFloat? {
        guard let desktopFrame = NSScreen.main?.visibleFrame else {
            return nil
        }
        let screenFrame = NSScreen.main?.frame
        let menuBarHeight = screenFrame!.height - desktopFrame.height
        return menuBarHeight
    }
}
