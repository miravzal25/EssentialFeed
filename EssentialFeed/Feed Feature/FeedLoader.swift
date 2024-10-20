//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 20/12/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
