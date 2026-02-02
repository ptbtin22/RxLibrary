//
//  BookListViewModel.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class BookListViewModel {
    private let stateRelay: BehaviorRelay<BookListViewState> = .init(value: .loading)
    
    private let booksRepository: BooksRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    private let searchInputRelay = PublishRelay<String?>()
    
    init(booksRepository: BooksRepositoryProtocol) {
        self.booksRepository = booksRepository
        setupBindings()
    }
    
}

// MARK: - Private

extension BookListViewModel {
    private func setupBindings() {
        searchInputRelay
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<BookListViewState> in
                guard let self, let query, !query.isEmpty else {
                    return .just(.success([]))
                }
                
                return self.booksRepository.searchBooks(query: query)
                    .asObservable()
                    .map { BookListViewState.success($0) }
                    .catch { .just(.error($0)) }
                    .startWith(.loading)
            }
            .bind(to: stateRelay)
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewModelProtocol

extension BookListViewModel: BookListViewModelProtocol {
    var state: Observable<BookListViewState> {
        stateRelay.asObservable()
    }
    
    var searchInput: AnyObserver<String?> {
        AnyObserver { [weak self] event in
            guard let element = event.element else { return }
            self?.searchInputRelay.accept(element)
        }
    }
}
