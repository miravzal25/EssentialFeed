//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 11/29/24.
//

import Foundation

final class FeedCachePolicy {
    private init() { }
    
    private static let calendar = Calendar(identifier: .gregorian)
    private static let maxCacheAgeInDays: Int = 7
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        return date < maxCacheAge
    }
}
