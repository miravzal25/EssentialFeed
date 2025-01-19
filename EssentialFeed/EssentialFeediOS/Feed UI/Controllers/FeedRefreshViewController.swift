//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/15/25.
//

import UIKit
import EssentialFeed

public final class FeedRefreshViewController: NSObject {
    private let viewModel: FeedViewModel

    public lazy var view = binded(UIRefreshControl())

    public init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc public func refresh() {
        viewModel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
