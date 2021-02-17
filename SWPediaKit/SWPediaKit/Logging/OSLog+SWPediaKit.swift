//
//  OSLog+SWPediaKit.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation
import os.log

public extension OSLog {
    private static var subsystem: String {
        Bundle.main.bundleIdentifier ?? "SWPediaKit"
    }
    
    static let net = OSLog(subsystem: subsystem, category: "Net")
}
