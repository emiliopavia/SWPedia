//
//  HTTPURLResponse+SWPediaKit.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        statusCode >= 200 && statusCode < 300
    }
}
