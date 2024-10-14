//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Miravzal Sultonov on 10/14/24.
//

import XCTest

class LocalFeedLoader {
    init(feedStore: FeedStore) {
        
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
}
