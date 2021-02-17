//
//  API.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation

public enum HTTPMethod: String {
    case get, post, put, delete
}

public enum APIError: Error, Equatable {
    case invalidRequest
    case networkError(NSError?)
    case httpError(Int, Data?)
    case badResponse
}

public protocol APIRequest {
    associatedtype Response: Decodable
    
    var method: HTTPMethod { get }
    var url: URL { get }
    var parameters: [String: String?]? { get }
    var contentType: String { get }
    
    var decoder: JSONDecoder { get }
}

public extension APIRequest {
    var method: HTTPMethod { .get }
    var parameters: [String: String?]? { nil }
    var contentType: String { "application/json" }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
