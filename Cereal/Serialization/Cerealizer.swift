//
// Created by Joshua Gretz on 11/1/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

@objc public protocol Cerealizer {
    var dateFormatter:DateFormatter! {get set}

    func toString(_ obj:AnyObject?)->String

    func toPropertyBag(_ obj:NSObject?)->Dictionary<String,AnyObject>
    func toArrayOfPropertyBags(_ obj:Array<NSObject>)->Array<Dictionary<String,AnyObject>>

    func create(_ type:AnyClass, fromString:String)->AnyObject?
    func create(_ type:AnyClass, fromObject:AnyObject) -> AnyObject?
}
