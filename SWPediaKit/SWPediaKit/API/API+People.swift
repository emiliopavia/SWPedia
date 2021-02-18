//
//  API+People.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation

public struct PeopleRequest: APIRequest {
    public typealias Response = APIPaginatedResponse<Person>
    
    public var url: URL
    public var parameters: [String : String?]?
    
    public init(url: URL, query: String?) {
        self.url = url
        
        if let query = query, !query.isEmpty {
            parameters = ["search": query]
        }
    }
}
