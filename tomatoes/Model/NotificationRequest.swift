//
//  Notification.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 23/7/2025.
//

import Foundation
import UserNotifications

class NotificationRequest {
    private var time: Date
    private var content: UNMutableNotificationContent?
    
    init(time: Date) {
        self.time = time
    }
    
    func buildContent() -> UNMutableNotificationContent {
        guard self.content == nil else {
            return self.content!
        }
        let content = UNMutableNotificationContent()
        content.title = "tomatoes"
        content.body = "notification body"
        self.content = content
        return content
    }
    
    func buildTrigger() -> UNNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: self.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return trigger
    }
    
    func getNotificationRequest() -> UNNotificationRequest {
        let content = buildContent()
        let trigger = buildTrigger()
        return UNNotificationRequest(
            identifier: "tomatoes",
            content: content,
            trigger: trigger
        )
    }
    
}


