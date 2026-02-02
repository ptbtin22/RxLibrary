//
//  OpenLibraryDataSource.swift
//  RxLibrary
//
//  Created by Tin Pham on 2/2/26.
//

import Foundation
import RxSwift

class OpenLibraryRemoteDataSource {
    lazy var httpClient: HTTPClientProtocol = HTTPClient()
}
    
// MARK: - BooksRemoteDataSource

extension OpenLibraryRemoteDataSource: BooksRemoteDataSource {
    func searchBooks(query: String) -> Single<[BookDTO]> {
        let endpoint = BooksAPIEndpoints.searchBooks(query: query)
        return httpClient.request(endpoint)
            .map { (response: BookSearchResponse) in
                return response.docs
            }
    }
}
