//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Miravzal Sultonov on 1/14/25.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {
    var isShowingLocation: Bool {
        !locationContainer.isHidden
    }

    var locationText: String? {
        locationLabel.text
    }

    var descriptionText: String? {
        descriptionLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        feedImageContainer.isShimmering
    }
    
    var renderedImageData: Data? {
        feedImageView.image?.pngData()
    }
    
    var isShowingRetryAction: Bool {
        !feedImageRetryButton.isHidden
    }
    
    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
}
