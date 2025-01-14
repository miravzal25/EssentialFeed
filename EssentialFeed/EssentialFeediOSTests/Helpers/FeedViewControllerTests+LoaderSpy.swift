//
//  FeedViewControllerTests+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by Miravzal Sultonov on 1/14/25.
//

import Foundation
import EssentialFeed
import EssentialFeediOS

extension FeedViewControllerTests {

    class LoaderSpy: FeedLoader, FeedImageDataLoader {

        // MARK: - FeedLoader
        
        private var feedRequests: [((FeedLoader.Result) -> Void)] = []
        
        var loadFeedCallCount: Int {
            feedRequests.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            feedRequests.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            feedRequests[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        
        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallback: () -> Void
            
            func cancel() {
                cancelCallback()
            }
        }
        
        private(set) var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        private(set) var cancelledImageURLs: [URL] = []
        
        var loadedImageURLs: [URL] {
            imageRequests.map(\.url)
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            imageRequests.append((url, completion))
            
            return TaskSpy { [weak self] in
                self?.cancelledImageURLs.append(url)
            }
        }
        
        func completeImageLoading(with data: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(data))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}
