//
//  SomeServiceProtocol.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxSwift

protocol BooksRemoteDataSource {
    func getTitles() -> Single<[String]>
}

class OpenLibraryRemoteDataSource: BooksRemoteDataSource {
    func getTitles() -> Single<[String]> {
        return Single.create { single in
            let workItem = DispatchWorkItem {
                single(.success(["RxSwift for Beginners", "Advanced iOS", "Clean Architecture"]))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
            return Disposables.create {
                workItem.cancel()
            }
        }
    }
}
