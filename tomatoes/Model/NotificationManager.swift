//
//  NotificationManager.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 23/7/2025.
//

import UserNotifications

class NotificationManager {
    var currentCenter = UNUserNotificationCenter.current()
    
    func requestAuthorisationForNotifications() {
        currentCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("Notification Authorisation request granted")
            }
        }
    }
    
    func scheduleNotification(time: Date, currentMode: TimerLogic.Mode, currentDuration: String) async {
        let notification = NotificationRequest(time: time).getNotificationRequest(currentMode: currentMode, currentDuration: currentDuration)
        do {
            try await currentCenter.add(notification)
            print("Notification scheduled for: \(time)")
        } catch {
            print(error)
        }
    }
    
    func removeAllScheduledNotifications() {
        currentCenter.removeAllPendingNotificationRequests()
    }
}



