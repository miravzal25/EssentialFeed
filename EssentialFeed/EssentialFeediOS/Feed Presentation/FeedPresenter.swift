//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/19/25.
//

import EssentialFeed

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    private let loaderView: FeedLoadingView
    private let feedView: FeedView
    
    init(loaderView: FeedLoadingView, feedView: FeedView) {
        self.loaderView = loaderView
        self.feedView = feedView
    }
    
    func didStartLoadingFeed() {
        loaderView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loaderView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loaderView.display(FeedLoadingViewModel(isLoading: false))
    }
}
