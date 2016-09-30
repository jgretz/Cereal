//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

open class CaseInsensitiveKeyTransform: CerealKeyTransform {
    
    public init() {}
    
    open func transformKey(_ string: String) -> String {
        return string
    }

    open func propertyName(_ properties: Array<CMPropertyInfo>, forKey: String) -> String? {
        let property = properties.filter({ (p: CMPropertyInfo) in p.name.compare(forKey, options: NSString.CompareOptions.caseInsensitive) == ComparisonResult(rawValue: 0) })
        return property.count == 0 ? forKey : property[0].name
    }
}
