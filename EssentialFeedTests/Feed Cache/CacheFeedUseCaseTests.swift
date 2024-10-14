//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Miravzal Sultonov on 10/14/24.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    private let feedStore: FeedStore
    
    init(feedStore: FeedStore) {
        self.feedStore = feedStore
    }
    
    func save(_ items: [FeedItem]) {
        feedStore.deleteCachedFeedCallCount += 1
    }
}

class FeedStore {
    var deleteCachedFeedCallCount: Int = 0
}

final class CacheFeedUseCaseTests: XCTestCase {

   
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        let _ = LocalFeedLoader(feedStore: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let store = FeedStore()
        let useCase = LocalFeedLoader(feedStore: store)
        let items = [uniqueItem(), uniqueItem()]
        
        useCase.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func uniqueItem() -> FeedItem {
        FeedItem(
            id: UUID(),
            description: "any",
            location: "any",
            imageURL: anyURL()
        )
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
}
