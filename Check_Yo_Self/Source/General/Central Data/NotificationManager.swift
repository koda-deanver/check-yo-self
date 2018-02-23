//
//  NotificationManager.swift
//  Check_Yo_Self
//
//  Created by Phil on 2/23/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

enum NotificationType {
    
    case profileUpdated
    
    var notification: Notification {
        switch self {
        case .profileUpdated: return Notification(name: Notification.Name("profileUpdated"))
        }
    }
}
class NotificationManager {
    
    static let shared = NotificationManager()
    
    func postNotification(ofType notificationType: NotificationType) {
        NotificationCenter.default.post(notificationType.notification)
    }
    
    func addObserver(_ observer: Any, forNotificationType notificationType: NotificationType, handler: Selector) {
        
        NotificationCenter.default.addObserver(observer, selector: handler, name: notificationType.notification.name, object: nil)
    }
}
