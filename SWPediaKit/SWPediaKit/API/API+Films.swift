//
//  API+Films.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 19/02/21.
//

import Foundation

public struct FilmRequest: APIRequest {
    public typealias Response = Film
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
