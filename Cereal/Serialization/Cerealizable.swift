//
// Created by Joshua Gretz on 11/2/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

public protocol Cerealizable {
    func shouldSerializeProperty(propertyName: String) -> Bool

    func overrideSerializeProperty(propertyName: String) -> Bool

    func serializeProperty(propertyName: String) -> AnyObject?
}
