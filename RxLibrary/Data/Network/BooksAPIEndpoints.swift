//
//  BooksAPIEndpoints.swift
//  RxLibrary
//
//  Created by Tin Pham on 2/2/26.
//

import Foundation

enum BooksAPIEndpoints {
    case searchBooks(query: String)
}

extension BooksAPIEndpoints: Endpoint {
    var baseURL: String {
        return "https://openlibrary.org"
    }
    
    var path: String {
        switch self {
        case .searchBooks:
            return "/search.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchBooks:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .searchBooks(let query):
            return ["title": query, "limit": 20]
        }
    }
}
