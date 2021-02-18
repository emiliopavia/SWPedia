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
    
    public init(url: URL) {
        self.url = url
    }
}
