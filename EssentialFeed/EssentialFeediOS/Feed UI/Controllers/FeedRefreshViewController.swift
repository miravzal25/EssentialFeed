//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/15/25.
//

import UIKit
import EssentialFeed

public final class FeedRefreshViewController: NSObject {
    public lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let feedLoader: FeedLoader
    
    public var onRefresh: (([FeedImage]) -> Void)?

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    @objc public func refresh() {
        view.beginRefreshing()
        
        feedLoader.load { [weak self] result in
            if case .success(let feed) = result {
                self?.onRefresh?(feed)
            }
            
            self?.view.endRefreshing()
        }
    }
}
