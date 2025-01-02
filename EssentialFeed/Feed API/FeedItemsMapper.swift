//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 25/12/23.
//

import Foundation

final class FeedItemsMapper {

    struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    static var OK_200: Int { 200 }

    static func map(data: Data, response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
