//
//  ViewModel.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class ViewModel {
    private let stateRelay: BehaviorRelay<ViewState> = .init(value: .loading)
    
    private let someService: SomeServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(someService: SomeServiceProtocol) {
        self.someService = someService
        
        setupBindings()
    }
    
}

// MARK: - Private

extension ViewModel {
    private func setupBindings() {
        stateRelay.accept(.loading)
        
        someService
            .getTitles()
            .subscribe(
                onSuccess: { [weak self] titles in
                    self?.stateRelay.accept(.success(titles))
                },
                onFailure: { [weak self] error in
                    self?.stateRelay.accept(.error(error))
                }
            )
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewModelProtocol

extension ViewModel: ViewModelProtocol {
    var state: Observable<ViewState> {
        stateRelay.asObservable()
    }
}
