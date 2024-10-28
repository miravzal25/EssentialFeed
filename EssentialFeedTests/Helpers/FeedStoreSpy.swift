//
//  FeedStoreSpy.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 10/27/24.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    var receivedMessages: [ReceivedMessage] = []
    var deletionCompletions: [DeletionCompletion] = []
    var insertionCompletions: [DeletionCompletion] = []
    var retrievalCompletions: [RetrievalCompletion] = []
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func completeRetrival(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](error)
    }
    
    func deleteFeedCache(completion: @escaping DeletionCompletion) {
        receivedMessages.append(.deleteCachedFeed)
        deletionCompletions.append(completion)
    }
    
    func insert(_ feed: [LocalFeedImage], timesamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timesamp))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
}
