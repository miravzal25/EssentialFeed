//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 10/18/24.
//

import Foundation

public enum RetrieveCacheFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
    
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCacheFeedResult) -> Void
    
    func deleteFeedCache(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
