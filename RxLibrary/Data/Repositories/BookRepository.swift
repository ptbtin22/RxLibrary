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
        return remoteDataSource.searchBooks(query: query)
            .map { dtos in
                dtos.map { $0.toDomain() }
            }
    }
}
