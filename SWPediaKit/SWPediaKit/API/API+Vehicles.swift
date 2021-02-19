//
//  API+Vehicles.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 19/02/21.
//

import Foundation

public struct VehicleRequest: APIRequest {
    public typealias Response = Vehicle
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
