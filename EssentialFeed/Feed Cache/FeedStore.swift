//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 10/18/24.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteFeedCache(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timesamp: Date, completion: @escaping InsertionCompletion)
}
