//
// Created by Joshua Gretz on 11/1/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

open class JsonCerealizer : CerealizerBase {
    open override func toString(_ obj:AnyObject?)->String {
        var object:AnyObject
        if (obj is Array<NSObject>) {
            object = self.toArrayOfPropertyBags(obj as! Array<NSObject>) as AnyObject
        }
        else if (obj is NSObject) {
            object = self.toPropertyBag(obj as? NSObject) as AnyObject
        }
        else {
            return ""
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        }
        catch {
            NSLog("Error Serializing Object")
            return ""
        }
    }

    open override func create(_ type:AnyClass, fromString:String)->AnyObject? {
        let data = fromString.data(using: String.Encoding.utf8)
        if (data == nil) {
            return nil
        }

        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            return create(type, fromObject: jsonObj as AnyObject)
        }
        catch {
            if (!fromString.isEmpty) {
                NSLog("Error Deserializing Object")
            }
            return nil
        }
    }
}
