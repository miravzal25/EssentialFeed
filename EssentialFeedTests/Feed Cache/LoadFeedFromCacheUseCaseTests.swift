//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Miravzal Sultonov on 10/27/24.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrivalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, completeWith: .failure(retrievalError), when: {
            store.completeRetrival(with: retrievalError )
        })
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, completeWith: .success([]), when: {
            store.completeRetrieveWithEmptyCache()
        })
    }
    
    func test_load_deliversCachedImagesOnLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let lessThanSevenDaysOldDate = Date().adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        expect(sut, completeWith: .success(feed.models), when: {
            store.completeRetrieve(with: feed.local, timestamp: lessThanSevenDaysOldDate)
        })
    }
    
    func test_load_deliversNoImagesOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let sevenDaysOldDate = Date().adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        expect(sut, completeWith: .success([]), when: {
            store.completeRetrieve(with: feed.local, timestamp: sevenDaysOldDate)
        })
    }
    
    func test_load_deliversNoImagesOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let moreThanSevenDaysOldDate = Date().adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        expect(sut, completeWith: .success([]), when: {
            store.completeRetrieve(with: feed.local, timestamp: moreThanSevenDaysOldDate)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrivalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrival(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieveWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let lessThanSevenDaysOldDate = Date().adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        sut.load { _ in }
        store.completeRetrieve(with: feed.local, timestamp: lessThanSevenDaysOldDate)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let sevenDaysOldDate = Date().adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        sut.load { _ in }
        store.completeRetrieve(with: feed.local, timestamp: sevenDaysOldDate)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let currentDate = Date()
        let moreThanSevenDaysOldDate = Date().adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { currentDate })
        
        sut.load { _ in }
        store.completeRetrieve(with: feed.local, timestamp: moreThanSevenDaysOldDate)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [LocalFeedLoader.LoadResult]()
        sut?.load { result in
            receivedResults.append(result)
        }
        sut = nil
        
        store.completeRetrieveWithEmptyCache()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalFeedLoader,
        completeWith expectedResult: LocalFeedLoader.LoadResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
    }
}

