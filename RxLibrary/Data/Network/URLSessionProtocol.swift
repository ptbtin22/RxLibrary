//
//  URLSessionProtocol.swift
//  RxLibrary
//
//  Created by Tin Pham on 2/2/26.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

// MARK: - URLSessionDataTask

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: - URLSession

extension URLSession: URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTaskProtocol {
        let task: URLSessionDataTask = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
}
