//
//  API+APIRoot.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation

public struct RootRequest: APIRequest {
    public typealias Response = APIRoot
    
    public var url: URL
    
    public init(baseURL: URL) {
        url = baseURL
    }
}
