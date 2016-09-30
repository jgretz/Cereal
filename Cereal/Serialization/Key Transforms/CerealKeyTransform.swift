//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

public protocol CerealKeyTransform {
    
    func transformKey(_ string: String) -> String

    func propertyName(_ properties: Array<CMPropertyInfo>, forKey: String) -> String?
}
