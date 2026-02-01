//
//  BookRepositoryProtocol.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxSwift

protocol BooksRepositoryProtocol {
    func searchBooks(query: String) -> Single<[Book]>
}
