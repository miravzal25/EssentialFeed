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
    private let calendar = Calendar(identifier: .gregorian)
    private let maxCacheAgeInDays: Int = 7
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteFeedCache { [weak self] error in
            guard let self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                cache(feed, completion: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case let .found(feed, timestamp) where validate(timestamp):
                completion(.success(feed.toModels()))
                
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
    
    public func validateCache() {
        store.retrieve { [unowned self] result in
            
            switch result {
            case .failure:
                store.deleteFeedCache { _ in }
            
            case let .found(_, timestamp) where !self.validate(timestamp):
                store.deleteFeedCache { _ in }
            
            case .empty, .found:
                break
            }
        }
        
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        return currentDate() < maxCacheAge
    }
    
    private func cache(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timesamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
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
