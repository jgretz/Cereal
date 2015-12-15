//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

public class CaseInsensitiveKeyTransform: CerealKeyTransform {
    
    public init() {}
    
    public func transformKey(string: String) -> String {
        return string
    }

    public func propertyName(properties: Array<CMPropertyInfo>, forKey: String) -> String? {
        let property = properties.filter({ (p: CMPropertyInfo) in p.name.compare(forKey, options: NSStringCompareOptions.CaseInsensitiveSearch) == NSComparisonResult(rawValue: 0) })
        return property.count == 0 ? forKey : property[0].name
    }
}
