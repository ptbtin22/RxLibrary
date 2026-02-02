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
    let coverId: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorNames = "author_name"
        case coverId = "cover_i"
    }
}

struct BookSearchResponse: Decodable {
    let docs: [BookDTO]
}

// MARK: - toDomain

extension BookDTO {
    func toDomain() -> Book {
        let url: URL?
        if let coverId {
            url = URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg")
        } else {
            url = nil
        }
        return Book(title: title, authorNames: authorNames, coverURL: url)
    }
}
