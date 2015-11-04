//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

public class PascalCaseKeyTransform: CerealKeyTransform {
    public func transformKey(string: String) -> String {
        let index = string.startIndex.advancedBy(1)

        return string.substringToIndex(index).uppercaseString.stringByAppendingString(string.substringFromIndex(index))
    }

    public func propertyName(properties: Array<CMPropertyInfo>, forKey: String) -> String? {
        let potential = self.transformKey(forKey)
        return properties.any({ $0.name == potential }) ? potential : nil
    }
}
