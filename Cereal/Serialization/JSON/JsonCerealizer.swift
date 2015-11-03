//
// Created by Joshua Gretz on 11/1/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation

public class JsonCerealizer : CerealizerBase {
    public override func toString(obj:AnyObject?)->String {
        var object:AnyObject
        if (obj is Array<NSObject>) {
            object = self.toArrayOfPropertyBags(obj as! Array<NSObject>)
        }
        else if (obj is NSObject) {
            object = self.toPropertyBag(obj as? NSObject)
        }
        else {
            return ""
        }

        do {
            let data = try NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions(rawValue: 0))
            return String(data: data, encoding: NSUTF8StringEncoding) ?? ""
        }
        catch {
            NSLog("Error Serializing Object")
            return ""
        }
    }

    public override func create(type:AnyClass, fromString:String)->AnyObject? {
        let data = fromString.dataUsingEncoding(NSUTF8StringEncoding)
        if (data == nil) {
            return nil
        }

        do {
            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            return create(type, fromObject: jsonObj)
        }
        catch {
            if (!fromString.isEmpty) {
                NSLog("Error Deserializing Object")
            }
            return nil
        }
    }
}
