//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/14/25.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
