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
            print("Notification authorisation request granted")
        }
    }
    
    func scheduleNotification(time: Date) async {
        let notification = NotificationRequest(time: time).getNotificationRequest()
        do {
            try await currentCenter.add(notification)
        } catch {
            print(error)
        }
    }
    
}



