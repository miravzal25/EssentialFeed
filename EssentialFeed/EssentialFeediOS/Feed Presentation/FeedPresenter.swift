//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/19/25.
//

import EssentialFeed

public protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

public protocol FeedView {
    func display(feed: [FeedImage])
}

public final class FeedPresenter {
    private let feedLoader: FeedLoader
    
    public weak var loaderView: FeedLoadingView?
    public var feedView: FeedView?
    
    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    public func loadFeed() {
        loaderView?.display(isLoading: true)
        
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loaderView?.display(isLoading: false)
        }
    }
}
