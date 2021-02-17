//
//  API+URLSession.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation

extension APIRequest {
    public func build() throws -> URLRequest {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidRequest
        }
        
        if let parameters = self.parameters, !parameters.isEmpty {
            var queryItems = [URLQueryItem]()
            for key in parameters.keys.sorted() {
                if let value = parameters[key] {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let requestURL = urlComponents.url else {
            throw APIError.invalidRequest
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
