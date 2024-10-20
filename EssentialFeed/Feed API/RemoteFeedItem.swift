//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 10/20/24.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
