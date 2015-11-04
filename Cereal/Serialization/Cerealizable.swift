//
// Created by Joshua Gretz on 11/2/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

public protocol Cerealizable {
    //***************
    // Serialization
    //***************

    func shouldSerializeProperty(propertyName: String) -> Bool

    func overrideSerializeProperty(propertyName: String) -> Bool

    func serializeProperty(propertyName: String) -> AnyObject?

    //*****************
    // Deserialization
    //*****************

    func typeFor(propertyName: String, value: AnyObject?) -> AnyClass

    func shouldDeserializeProperty(propertyName: String) -> Bool

    func overrideDeserializeProperty(propertyName: String, value: AnyObject?) -> Bool

    func deserializeProperty(propertyName: String, value: AnyObject?)
}
