//
//  NotificationCenterNameConstructor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 14.07.2022.
//

import Foundation

final class NotificationCenterNameConstructor {
    
    static func likeProfile(postID: UUID) -> String {
        return NotificationCenterNames.like.rawValue + NotificationCenterNames.profile.rawValue + postID.uuidString
    }
    
    static func dislikeProfile(postID: UUID) -> String {
        return NotificationCenterNames.dislike.rawValue + NotificationCenterNames.profile.rawValue + postID.uuidString
    }
    
    static func likeFeed(postID: UUID) -> String {
        return NotificationCenterNames.like.rawValue + NotificationCenterNames.feed.rawValue + postID.uuidString
    }
    
    static func dislikeFeed(postID: UUID) -> String {
        return NotificationCenterNames.dislike.rawValue + NotificationCenterNames.feed.rawValue + postID.uuidString
    }
    
}
