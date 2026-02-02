//
//  BookListViewModelProtocol.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxSwift

enum BookListViewState {
    case loading
    case success([Book])
    case error(Error)
}

protocol BookListViewModelProtocol {
    var state: Observable<BookListViewState> { get }
    var searchInput: AnyObserver<String?> { get }
}
