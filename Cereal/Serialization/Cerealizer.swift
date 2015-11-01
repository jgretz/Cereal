//
// Created by Joshua Gretz on 11/1/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

@objc protocol Cerealizer {
    func toString(obj:NSObject)->String

    func toPropertyBag(obj:NSObject)->Dictionary<String,AnyObject>
    func toArrayOfPropertyBags(obj:Array<NSObject>)->Array<Dictionary<String,AnyObject>>

    func create(type:AnyClass, fromString:String)->AnyObject
}
