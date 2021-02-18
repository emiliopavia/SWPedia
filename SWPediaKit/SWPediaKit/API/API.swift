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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
}

public struct APIPaginatedResponse<T: Decodable>: Decodable {
    public let count: Int
    public let next: URL?
    public let previous: URL?
    public let results: [T]
}
