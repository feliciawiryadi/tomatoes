//
//  NotificationManager.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 23/7/2025.
//

import UserNotifications


func requestAuthorisationForNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
        print(granted)
    }
}
