//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Miravzal Sultonov on 09/04/24.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private struct UnexpectedValuesRepresentation: Error { }

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error {
                completion(.failure(error))
            } else if let data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }).resume()
    }
}
