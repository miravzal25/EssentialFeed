//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 20/12/23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageUrl: URL
}
