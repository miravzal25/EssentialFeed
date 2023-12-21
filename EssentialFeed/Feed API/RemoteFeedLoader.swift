//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 21/12/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

final public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() {
        client.get(from: url)
    }
}
