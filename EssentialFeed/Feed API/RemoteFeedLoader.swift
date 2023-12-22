//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 21/12/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

final public class RemoteFeedLoader {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private let client: HTTPClient
    private let url: URL

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { (error, response) in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}
