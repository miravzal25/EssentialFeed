//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 20/12/23.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
