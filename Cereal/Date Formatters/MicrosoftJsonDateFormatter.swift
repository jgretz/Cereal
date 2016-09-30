//
// Created by Scott Ferguson on 12/30/13.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

open class MicrosoftJsonDateFormatter: DateFormatter {
    open override func date(from string:String) -> Date? {
        if (string.characters.count == 0) {
            return nil
        }

        // Remove escape characters and the Date() text from the raw JSON date string.
        let startIndex = string.range(of: "(")!.lowerBound
        let endIndex = string.range(of: ")")!.lowerBound
        var datePart = string.substring(with: (startIndex ..< endIndex))

        // Determine if the UTC portion is present and extract it and the direction.
        let plusRange = datePart.range(of: "+")
        let minusRange = datePart.range(of: "-")

        // Default the values as if the UTC portion does not exist.
        var timeZoneHoursPart = "00"
        var timeZoneMinutesPart = "00"
        var timeZoneMultiplier = 0
        
        if (plusRange != nil || minusRange != nil) {
            timeZoneMultiplier = plusRange != nil ? 1 : -1
            
            let range = plusRange != nil ? plusRange! : minusRange!
            
            let hoursStart = string.index(range.lowerBound, offsetBy: 1)
            let hoursEnd = string.index(range.lowerBound, offsetBy: 3)
            let hoursRange = hoursStart ..< hoursEnd;
            
            timeZoneHoursPart = datePart.substring(with: hoursRange)
            
            let minutesStart = string.index(range.lowerBound, offsetBy: 3)
            let minutesEnd = string.index(range.lowerBound, offsetBy: 5)
            let minutesRange = minutesStart ..< minutesEnd;
            
            timeZoneMinutesPart = datePart.substring(with: minutesRange)
            
            datePart = datePart.substring(to: range.lowerBound)
        }

        // Convert the parts.
        let time = Float(datePart)! / 1000
        let offsetHours = Float(timeZoneHoursPart)! * 3600.0 * Float(timeZoneMultiplier)
        let offsetMinutes = Float(timeZoneMinutesPart)! * 60.0 * Float(timeZoneMultiplier)

        // create the date
        return Date(timeIntervalSince1970: TimeInterval(time + offsetHours + offsetMinutes))
    }

    open override func string(from date:Date) -> String {
        return String(format: "/Date{%llu}/", date.timeIntervalSince1970 * 1000)
    }
}
