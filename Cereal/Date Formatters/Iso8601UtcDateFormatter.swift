//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

public class Iso8601UtcDateFormatter : NSDateFormatter {
    public override init() {
        super.init()

        self.setFormats()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setFormats()
    }

    private func setFormats() {
        self.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        self.timeZone = NSTimeZone(abbreviation: "UTC")
        self.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSS'Z'"
    }

    public override func dateFromString(var string:String) -> NSDate? {
        // Handle dates with or without the MS portion
        if (string.componentsSeparatedByString(".").count == 1) {
            string = string.stringByAppendingString(".00000")
        }

        return super.dateFromString(string)
    }
}
