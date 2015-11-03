//
// Created by Joshua Gretz on 11/1/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

class Tree {
    var type:String?
}

class Flower:NSObject,Cerealizable {
    var type:String?
    var color:String?
    var planted:NSDate?
    var petals:Array<Petal>?

    func shouldSerializeProperty(propertyName: String) -> Bool  {
        return true
    }

    func overrideSerializeProperty(propertyName: String) -> Bool {
        return false
    }

    func serializeProperty(propertyName: String) -> AnyObject? {
        return nil
    }

    func shouldDeserializeProperty(propertyName: String) -> Bool {
        return true
    }

    func typeFor(propertyName: String, value: AnyObject?) -> AnyClass {
        if (propertyName == "petals") {
            return Petal.self
        }

        if (value != nil) {
            return value!.dynamicType
        }

        return NSObject.self
    }

    func overrideDeserializeProperty(propertyName: String, value: AnyObject?) -> Bool {
        return false
    }

    func deserializeProperty(propertyName: String, value: AnyObject?) {
    }
}

class Petal:NSObject {
    var color:String?

    convenience init(color:String) {
        self.init()

        self.color = color
    }
}
