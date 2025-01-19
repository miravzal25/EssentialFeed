//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/19/25.
//

import EssentialFeed

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    private let feedLoader: FeedLoader
    
    public var loaderView: FeedLoadingView?
    public var feedView: FeedView?
    
    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    public func loadFeed() {
        loaderView?.display(FeedLoadingViewModel(isLoading: true))
        
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(FeedViewModel(feed: feed))
            }
            self?.loaderView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
