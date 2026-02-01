//
//  ViewModelProtocol.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation
import RxSwift

enum ViewState {
    case loading
    case success([String])
    case error(Error)
}

protocol ViewModelProtocol {
    var state: Observable<ViewState> { get }
}
