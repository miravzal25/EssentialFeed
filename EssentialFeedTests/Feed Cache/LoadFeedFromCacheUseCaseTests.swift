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
        let retrivalError = anyNSError()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedError: Error?
        
        sut.load { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got \(result) instead")
            case .failure(let error):
                receivedError = error
            }
            exp.fulfill()
        }
        store.completeRetrival(with: retrivalError)
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, retrivalError)
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedImages: [FeedImage]?
        
        sut.load { result in
            switch result {
            case .success(let images):
                receivedImages = images
            case .failure:
                XCTFail("Expected success, got \(result) instead")
            }
            exp.fulfill()
        }
        store.completeRetrieveWithEmptyCache()
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedImages, [])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
