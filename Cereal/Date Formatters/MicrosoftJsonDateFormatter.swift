//
// Created by Scott Ferguson on 12/30/13.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

public class MicrosoftJsonDateFormatter: NSDateFormatter {
    public override func dateFromString(string:String) -> NSDate? {
        if (string.characters.count == 0) {
            return nil
        }

        // Remove escape characters and the Date() text from the raw JSON date string.
        let startIndex = string.rangeOfString("(")!.startIndex
        let endIndex = string.rangeOfString(")")!.startIndex
        var datePart = string.substringWithRange(Range(start: startIndex, end: endIndex))

        // Determine if the UTC portion is present and extract it and the direction.
        let plusRange = datePart.rangeOfString("+")
        let minusRange = datePart.rangeOfString("-")

        // Default the values as if the UTC portion does not exist.
        var timeZoneHoursPart = "00"
        var timeZoneMinutesPart = "00"
        var timeZoneMultiplier = 0

        if (plusRange != nil || minusRange != nil) {
            timeZoneMultiplier = plusRange != nil ? 1 : -1

            let range = plusRange != nil ? plusRange! : minusRange!
            timeZoneHoursPart = datePart.substringWithRange(Range(start: range.startIndex.advancedBy(1), end: range.startIndex.advancedBy(3)))
            timeZoneMinutesPart = datePart.substringWithRange(Range(start: range.startIndex.advancedBy(3), end: range.startIndex.advancedBy(5)))

            datePart = datePart.substringToIndex(range.startIndex)
        }

        // Convert the parts.
        let time = Float(datePart)! / 1000
        let offsetHours = Float(timeZoneHoursPart)! * 3600.0 * Float(timeZoneMultiplier)
        let offsetMinutes = Float(timeZoneMinutesPart)! * 60.0 * Float(timeZoneMultiplier)

        // create the date
        return NSDate(timeIntervalSince1970: NSTimeInterval(time + offsetHours + offsetMinutes))
    }

    public override func stringFromDate(date:NSDate) -> String {
        return String(format: "/Date{%llu}/", date.timeIntervalSince1970 * 1000)
    }
}
