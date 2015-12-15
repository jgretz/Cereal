//
//  UnderscoreKeyTransform.swift
//  Cereal
//
//  Created by Andrew Holt on 12/10/15.
//  Copyright © 2015 Truefit. All rights reserved.
//

import CoreMeta

public class UnderscoreKeyTransform: CerealKeyTransform {
    
    public init() {}
    
    public func transformKey(string: String) -> String {
        return string.characters.map(prefixUppercaseWithUnderscore).joinWithSeparator("")
    }
    
    public func propertyName(properties: [CMPropertyInfo], forKey: String) -> String? {
        return properties.first { transformKey($0.name) == forKey }?.name ?? forKey
    }
    
    private func prefixUppercaseWithUnderscore(c: Character) -> String {
        let s = String(c)
        return s.rangeOfString("[A-Z]", options: .RegularExpressionSearch) != nil
            ? "_\(s.lowercaseString)"
            : s
    }
}
