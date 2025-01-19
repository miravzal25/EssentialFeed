//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/15/25.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private let presenter: FeedPresenter

    public lazy var view = loadView()

    public init(presenter: FeedPresenter) {
        self.presenter = presenter
    }
    
    @objc public func refresh() {
        presenter.loadFeed()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    public func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}
