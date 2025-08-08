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
    
    func buildContent(currentMode: TimerLogic.Mode, currentDuration: String) -> UNMutableNotificationContent {
        guard self.content == nil else {
            return self.content!
        }
        let content = UNMutableNotificationContent()
        content.title = "tomatoes"
        
        switch currentMode {
            case .focus:
                content.body = "you have focused for \(currentDuration) minutes"
            case .rest:
                content.body = "you have rested for \(currentDuration) minutes"
            default:
                content.body = ""
        }
        
        self.content = content
        return content
    }
    
    func buildTrigger() -> UNNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: self.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        return trigger
    }
    
    func getNotificationRequest(currentMode: TimerLogic.Mode, currentDuration: String) -> UNNotificationRequest {
        let content = buildContent(currentMode: currentMode, currentDuration: currentDuration)
        let trigger = buildTrigger()
        return UNNotificationRequest(
            identifier: "tomatoes",
            content: content,
            trigger: trigger
        )
    }
    
}


