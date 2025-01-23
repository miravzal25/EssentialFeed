//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/19/25.
//

import Foundation
import EssentialFeed

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    static var title: String {
        NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view"
        )
    }

    private let loaderView: FeedLoadingView
    private let feedView: FeedView
    
    init(loaderView: FeedLoadingView, feedView: FeedView) {
        self.loaderView = loaderView
        self.feedView = feedView
    }
    
    func didStartLoadingFeed() {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didStartLoadingFeed() }
        }
        
        loaderView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didStartLoadingFeed() }
        }
        
        feedView.display(FeedViewModel(feed: feed))
        loaderView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didStartLoadingFeed() }
        }
        
        loaderView.display(FeedLoadingViewModel(isLoading: false))
    }
}
