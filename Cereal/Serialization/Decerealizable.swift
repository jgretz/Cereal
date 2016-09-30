//
// Created by Joshua Gretz on 11/2/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

public protocol Decerealizable {
    
    func typeFor(_ propertyName: String, value: AnyObject?) -> AnyClass?

    func shouldDeserializeProperty(_ propertyName: String) -> Bool

    func overrideDeserializeProperty(_ propertyName: String, value: AnyObject?) -> Bool

    func deserializeProperty(_ propertyName: String, value: AnyObject?)
}

public extension Decerealizable {
    
    func typeFor(_ propertyName: String, value: AnyObject?) -> AnyClass? {
        return nil
    }
    
    func shouldDeserializeProperty(_ propertyName: String) -> Bool {
        return true
    }
    
    func overrideDeserializeProperty(_ propertyName: String, value: AnyObject?) -> Bool {
        return false
    }
    
    func deserializeProperty(_ propertyName: String, value: AnyObject?) {

    }
}
