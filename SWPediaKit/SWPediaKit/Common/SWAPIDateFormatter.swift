//
//  SWAPIDateFormatter.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 19/02/21.
//

import Foundation

class SWAPIDateFormatter: DateFormatter {
    override init() {
        super.init()
        dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        calendar = Calendar(identifier: .iso8601)
        timeZone = TimeZone(secondsFromGMT: 0)
        locale = Locale(identifier: "en_US_POSIX")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func date(from string: String) -> Date? {
        // The APIs have a bug that changes the date format
        // when milliseconds is 0. I've implemented a sort of
        // retry on failure that changes the format on the fly.
        // ¯\_(ツ)_/¯
        var date = super.date(from: string)
        if date == nil {
            let expectedFormat = dateFormat
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            date = super.date(from: string)
            dateFormat = expectedFormat
        }
        return date
    }
}
