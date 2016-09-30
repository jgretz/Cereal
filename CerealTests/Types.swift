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
    var planted:Date?
    var petals:Array<Petal>?
    var imageUrl: String?

    func shouldSerializeProperty(_ propertyName: String) -> Bool  {
        return true
    }

    func overrideSerializeProperty(_ propertyName: String) -> Bool {
        return false
    }

    func serializeProperty(_ propertyName: String) -> AnyObject? {
        return nil
    }

    func shouldDeserializeProperty(_ propertyName: String) -> Bool {
        return true
    }

    func typeFor(_ propertyName: String, value: AnyObject?) -> AnyClass {
        if (propertyName == "petals") {
            return Petal.self
        }

        if (value != nil) {
            return type(of: value!)
        }

        return NSObject.self
    }

    func overrideDeserializeProperty(_ propertyName: String, value: AnyObject?) -> Bool {
        return false
    }

    func deserializeProperty(_ propertyName: String, value: AnyObject?) {
    }
}

class Petal:NSObject {
    var color:String?

    convenience init(color:String) {
        self.init()

        self.color = color
    }
}
