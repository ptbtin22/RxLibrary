//
//  HTTPClient.swift
//  RxLibrary
//
//  Created by Tin Pham on 2/2/26.
//

import Foundation
import RxSwift

final class HTTPClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared
}

// MARK: - HTTPClientProtocol

extension HTTPClient: HTTPClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T> {
        return Single.create { observer in
            guard var components = URLComponents(string: endpoint.baseURL + endpoint.path) else {
                observer(.failure(URLError(.badURL)))
                return Disposables.create()
            }
            
            if let parameters = endpoint.parameters, endpoint.method == .get {
                components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
            
            guard let url = components.url else {
                observer(.failure(URLError(.badURL)))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            
            if let headers = endpoint.headers {
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            // Handle body for POST if needed
            if let parameters = endpoint.parameters, endpoint.method == .post {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let error {
                    observer(.failure(error))
                    return
                }
                
                guard let data else {
                    observer(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    observer(.success(result))
                } catch {
                    print("Decoding error: \(error)")
                    observer(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
