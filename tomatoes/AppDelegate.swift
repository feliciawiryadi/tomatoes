//
//  AppDelegate.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 20/7/2025.
//

import AppKit
import SwiftUI
import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusBarItem: NSStatusItem?
    var window: NSWindow?
//    var location: NSPoint = .zero
    
//    override var canBecomeKeyWindow: Bool {
//        return true
//    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusBarItem?.button {
            button.action = #selector(statusBarButtonClicked(_:))
            button.target = self
            button.image = NSImage(named: NSImage.Name("timelapse"))!
//            button.title = "tomatoes"
        }
    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        print("Status bar button clicked!")
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
        window?.contentView = NSHostingView(rootView: ContentView(timerLogic: TimerLogic()))
        window?.isReleasedWhenClosed = false
        window?.collectionBehavior = .canJoinAllSpaces
        window?.level = .floating
        
        return window.unsafelyUnwrapped
    }
    
    func toggleWindowVisibility(location: NSPoint) {
        if window == nil {
            return
        }
        
        if window!.isVisible {
            window?.orderOut(nil)
        } else {
            window?.setFrameOrigin(location)
            window?.makeKeyAndOrderFront(nil)
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
