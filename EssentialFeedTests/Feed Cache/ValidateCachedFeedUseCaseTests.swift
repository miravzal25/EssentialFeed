//
//  ValidateCachedFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Miravzal Sultonov on 10/27/24.
//

import XCTest
import EssentialFeed

final class ValidateCachedFeedUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrivalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrival(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrieveWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let lessThanSevenDaysOldDate = Date().adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        sut.validateCache()
        store.completeRetrieve(with: feed.local, timestamp: lessThanSevenDaysOldDate)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let sevenDaysOldDate = Date().adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        sut.validateCache()
        store.completeRetrieve(with: feed.local, timestamp: sevenDaysOldDate)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_deletesMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let moreThanSevenDaysOldDate = Date().adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        sut.validateCache()
        store.completeRetrieve(with: feed.local, timestamp: moreThanSevenDaysOldDate)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}

