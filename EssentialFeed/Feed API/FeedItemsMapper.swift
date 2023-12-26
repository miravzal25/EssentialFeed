//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 25/12/23.
//

import Foundation

class FeedItemsMapper {

    struct Root: Decodable {
        let items: [Item]

        var feeds: [FeedItem] {
            items.map(\.item)
        }
    }

    struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL

        var item: FeedItem {
            FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: image
            )
        }
    }

    static var OK_200: Int { 200 }

    static func map(data: Data, response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            return .failure(.invalidData)
        }
        
        return  .success(root.feeds)
    }
}
