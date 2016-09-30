//
//  UnderscoreKeyTransform.swift
//  Cereal
//
//  Created by Andrew Holt on 12/10/15.
//  Copyright © 2015 Truefit. All rights reserved.
//

import CoreMeta

open class UnderscoreKeyTransform: CerealKeyTransform {
    
    public init() {}
    
    open func transformKey(_ string: String) -> String {
        return string.characters.map(prefixUppercaseWithUnderscore).joined(separator: "")
    }
    
    open func propertyName(_ properties: [CMPropertyInfo], forKey: String) -> String? {
        return properties.first { transformKey($0.name) == forKey }?.name ?? forKey
    }
    
    fileprivate func prefixUppercaseWithUnderscore(_ c: Character) -> String {
        let s = String(c)
        return s.range(of: "[A-Z]", options: .regularExpression) != nil
            ? "_\(s.lowercased())"
            : s
    }
}
