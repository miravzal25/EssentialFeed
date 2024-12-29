//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 10/18/24.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                cache(feed, completion: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
    
extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case let .found(feed, timestamp) where FeedCachePolicy.validate(timestamp, against: currentDate()):
                completion(.success(feed.toModels()))
                
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}
    
extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure:
                store.deleteCachedFeed { _ in }
                
            case let .found(_, timestamp) where !FeedCachePolicy.validate(timestamp, against: currentDate()):
                store.deleteCachedFeed { _ in }
                
            case .empty, .found:
                break
            }
        }
        
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        map { image in
            LocalFeedImage(
                id: image.id,
                description: image.description,
                location: image.location,
                url: image.url
            )
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        map { image in
            FeedImage(
                id: image.id,
                description: image.description,
                location: image.location,
                url: image.url
            )
        }
    }
}
