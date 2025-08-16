//
//  Notification.swift
//  tomatoes
//
//  Created by Felicia Wiryadi on 23/7/2025.
//

import Foundation
import UserNotifications

/**
 # Notification request
 the object that is created for every notification
 builds: the content (including the customised content.body), the trigger, and action for when the manager wants to schedule a new notification
 */
class NotificationRequest {
    private var time: Date
    private var content: UNMutableNotificationContent?
    private var currentMode: TimerLogic.Mode?
    private var currentDuration: String?
    
    init(time: Date, mode: TimerLogic.Mode, duration: String) {
        self.time = time
        self.currentMode = mode
        self.currentDuration = duration
    }
    
    func buildContent() -> UNMutableNotificationContent {
        guard self.content == nil else {
            return self.content!
        }
        let content = UNMutableNotificationContent()
        content.title = "tomatoes"
        
        switch self.currentMode {
        case .focus:
            content.body = "you have focused for \(self.currentDuration!) minutes"
            content.categoryIdentifier = "focusModeCategory"
        case .rest:
            content.body = "you have rested for \(self.currentDuration!) minutes"
            content.categoryIdentifier = "restModeCategory"
        default:
            content.body = "unknown mode?"
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


