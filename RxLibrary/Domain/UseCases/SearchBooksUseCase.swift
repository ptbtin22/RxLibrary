//
//  SearchBooksUseCase.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxSwift

// 2. Use Case (Domain)
// Contains business logic (e.g., validation, combining data sources)
class SearchBooksUseCase {
    private let repository: BooksRepositoryProtocol

    init(repository: BooksRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) -> Single<[Book]> {
        // Business Rule Example: Don't search if query is too short
        if query.count < 3 {
             // Just return empty or error, logic decides
             return .just([])
        }
        return repository.searchBooks(query: query)
    }
}
