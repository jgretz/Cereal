//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

open class Iso8601UtcDateFormatter : DateFormatter {
    public override init() {
        super.init()

        self.setFormats()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setFormats()
    }

    fileprivate func setFormats() {
        self.locale = Locale(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSS'Z'"
    }

    open override func date(from string:String) -> Date? {
        var string = string
        // Handle dates with or without the MS portion
        if (string.components(separatedBy: ".").count == 1) {
            string = string + ".00000"
        }

        return super.date(from: string)
    }
}
