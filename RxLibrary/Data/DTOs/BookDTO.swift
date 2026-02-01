//
//  BookDTO.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import Foundation

struct BookDTO: Decodable {
    let title: String
    let authorNames: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorNames = "author_name"
    }
}

// MARK: - toDomain

extension BookDTO {
    func toDomain() -> Book {
        Book(title: title, authorNames: authorNames)
    }
}
