//
//  NotificationManager.swift
//  Check_Yo_Self
//
//  Created by Phil on 2/23/18.
//  Copyright © 2018 ThematicsLLC. All rights reserved.
//

import Foundation

/// Represents every type of notification throughout app.
enum NotificationType {
    
    case profileUpdated
    
    /// The notification object for this type.
    var notification: Notification {
        switch self {
        case .profileUpdated: return Notification(name: Notification.Name("profileUpdated"))
        }
    }
}

/// Provides interface for posting and listening to events.
class NotificationManager {
    
    static let shared = NotificationManager()
    
    ///
    /// Fire event of specified type.
    ///
    /// - parameter notificationType: The type of event to fire.
    ///
    func postNotification(ofType notificationType: NotificationType) {
        NotificationCenter.default.post(notificationType.notification)
    }
    
    ///
    /// Register an object to listen for specified event.
    ///
    /// - parameter observer: The object that will listen for event.
    /// - parameter notificationType: The type of event to listen for.
    /// - parameter handler: The block that will be run when event occurs.
    ///
    func addObserver(_ observer: Any, forNotificationType notificationType: NotificationType, handler: Selector) {
        
        NotificationCenter.default.addObserver(observer, selector: handler, name: notificationType.notification.name, object: nil)
    }
}
