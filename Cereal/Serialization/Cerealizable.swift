//
// Created by Joshua Gretz on 11/2/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

public protocol Cerealizable {
    func shouldSerializeProperty(_ propertyName: String) -> Bool

    func overrideSerializeProperty(_ propertyName: String) -> Bool

    func serializeProperty(_ propertyName: String) -> AnyObject?
}
