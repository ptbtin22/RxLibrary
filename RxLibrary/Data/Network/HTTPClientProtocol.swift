//
//  HTTPClientProtocol.swift
//  RxLibrary
//
//  Created by Tin Pham on 2/2/26.
//

import RxSwift

protocol HTTPClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T>
}
