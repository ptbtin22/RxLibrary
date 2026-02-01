//
//  BookRepository.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxSwift

class BooksRepository {
    private let remoteDataSource: BooksRemoteDataSource
    
    init(remoteDataSource: BooksRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
}
 
// MARK: - BooksRepositoryProtocol

extension BooksRepository: BooksRepositoryProtocol {
    func searchBooks(query: String) -> Single<[Book]> {
        // Here we could check a local database first (caching)
        // For now, we just pass through to remote
        return remoteDataSource.getTitles() // We might need to map or update the DataSource signature later
            .map { titles in
                // Mapping [String] specific mock to [Book]
                // Ideally DataSource returns DTOs, Repository maps to Domain Entities
                return titles.map { Book(title: $0, authorNames: ["Unknown"]) }
            }
    }
}
