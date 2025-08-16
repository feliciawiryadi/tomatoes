//
//  NotificationManager.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 23/7/2025.
//

import UserNotifications

/**
 # Notification Manager
 contains the UNUserNotificationCenter
 schedules notifications
 cancels/ remove scheduled notifications
 */
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
        let notification = NotificationRequest(time: time, mode: currentMode, duration: currentDuration).getNotificationRequest()
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



