//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

open class PascalCaseKeyTransform: CerealKeyTransform {
    
    public init() {}
    
    open func transformKey(_ string: String) -> String {
        let index = string.characters.index(string.startIndex, offsetBy: 1)
        
        return string.substring(to: index).uppercased() + string.substring(from: index)
    }

    open func propertyName(_ properties: Array<CMPropertyInfo>, forKey: String) -> String? {
        let potential = self.transformKey(forKey)
        return properties.any({ $0.name == potential }) ? potential : forKey
    }
}
