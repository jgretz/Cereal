//
// Created by Joshua Gretz on 11/1/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

public class CerealizerBase: NSObject, Cerealizer {
    public var dateFormatter: NSDateFormatter!
    public var serializeKeyTransform: CerealKeyTransform?
    public var deserializeKeyTransform: CerealKeyTransform?

    public override init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        self.deserializeKeyTransform = CaseInsensitiveKeyTransform()
    }

    //***********
    // Serialize
    //***********

    public func toString(obj: AnyObject?) -> String {
        return ""
    }

    public func toArrayOfPropertyBags(array: Array<NSObject>) -> Array<Dictionary<String, AnyObject>> {
        var returnArray = Array<Dictionary<String, AnyObject>>()
        for obj in array {
            returnArray.append(self.toPropertyBag(obj))
        }

        return returnArray
    }

    public func toPropertyBag(obj: NSObject?) -> Dictionary<String, AnyObject> {
        var bag = Dictionary<String, AnyObject>()
        if (obj == nil) {
            return bag;
        }

        let properties = CMTypeIntrospector(t: obj!.dynamicType).properties()
        for property in properties {
            if (obj is Cerealizable) {
                let cerealizable = obj as! Cerealizable
                if (!cerealizable.shouldSerializeProperty(property.name)) {
                    continue
                }

                if (cerealizable.overrideSerializeProperty(property.name)) {
                    bag[property.name] = cerealizable.serializeProperty(property.name)
                    continue
                }
            }

            let value = obj!.valueForKey(property.name)
            if (value == nil) {
                continue
            }

            let key = self.serializeKeyTransform == nil ? property.name : self.serializeKeyTransform!.transformKey(property.name)
            bag[key] = serializeValue(property.name, value: value!)
        }

        return bag
    }

    internal func serializeValue(propertyName: String, value: AnyObject) -> AnyObject {
        // handle straight return cases
        if (value is String || value is NSNumber) {
            return value
        }

        if (value is NSValue) {
            return NSKeyedArchiver.archivedDataWithRootObject(value).base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        }

        if (value is NSDate) {
            return self.dateFormatter.stringFromDate(value as! NSDate)
        }

        if (value is NSUUID) {
            return (value as! NSUUID).UUIDString
        }

        if (value is NSData) {
            return (value as! NSData).base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        }

        // collection types
        if (value is Array<NSObject>) {
            return self.toArrayOfPropertyBags(value as! Array<NSObject>)
        }

        if (value is Dictionary<String, NSObject>) {
            let sourceDict = value as! Dictionary<String, NSObject>
            var returnDict = Dictionary<String, NSObject>()
            for key in sourceDict.keys {
                returnDict[key] = self.toPropertyBag(sourceDict[key])
            }

            return returnDict
        }

        if (value is Set<NSObject>) {
            let sourceSet = value as! Set<NSObject>
            var returnArray = Array<NSObject>()
            for sourceItem in sourceSet {
                returnArray.append(self.toPropertyBag(sourceItem))
            }

            return returnArray
        }

        // object type
        if (value is NSObject) {
            return self.toPropertyBag(value as? NSObject)
        }

        // default
        return value
    }

    //*************
    // Deserialize
    //*************

    public func create(type: AnyClass, fromString: String) -> AnyObject? {
        return nil
    }

    internal func create(type: AnyClass, fromObject: AnyObject) -> AnyObject? {
        if (fromObject is Array<Dictionary<String, NSObject>>) {
            let dataArray: Array<Dictionary<String, NSObject>> = fromObject as! Array<Dictionary<String, NSObject>>

            var array = Array<NSObject>()
            for data in dataArray {
                let obj = NSObject.objectForType(type)
                fillObject(obj, data: data)

                array.append(obj)
            }

            return array
        } else if (fromObject is Dictionary<String, NSObject>) {
            let obj = NSObject.objectForType(type)
            fillObject(obj, data: fromObject as! Dictionary<String, NSObject>)

            return obj
        }

        return nil
    }

    internal func fillObject(obj: NSObject, data: Dictionary<String, AnyObject>) {
        let properties = CMTypeIntrospector(t: obj.dynamicType).properties()

        for dataKey in data.keys {
            // if we dont have a value, not sure how we are here, but protection
            var value = data[dataKey]
            if (value == nil) {
                continue
            }

            // override key with transform for object if applicable
            var key = dataKey
            if (self.deserializeKeyTransform != nil) {
                let mapped = self.deserializeKeyTransform!.propertyName(properties, forKey: key)
                if (mapped == nil) {
                    continue
                }

                key = mapped!
            }

            // allow decerealizable to override
            if (obj is Decerealizable) {
                let decerializable = obj as! Decerealizable
                if (!decerializable.shouldDeserializeProperty(key)) {
                    continue
                }

                if (decerializable.overrideDeserializeProperty(key, value: value)) {
                    decerializable.deserializeProperty(key, value: value)
                    continue
                }
            }

            // parse
            if (value is Dictionary<String, AnyObject>) {
                let property = properties.first({ $0.name == key })!
                let type: AnyClass = NSClassFromString(property.typeInfo.name)!

                value = self.create(type, fromObject: value!)

            } else if (value is Array<AnyObject>) {
                if (obj is Decerealizable) {
                    let sourceArray = value as! Array<AnyObject>
                    var targetArray = Array<AnyObject>()

                    for source in sourceArray {
                        let type:AnyClass? = (obj as! Decerealizable).typeFor(key, value: source)
                        if (type != nil) {
                            let item = self.create(type!, fromObject: source)
                            if (item != nil) {
                                targetArray.append(item!)
                            }
                        }
                    }

                    value = targetArray
                }
            } else {
                let item = deserializeValue(obj, properties: properties, propertyName: key, value: value!)
                if (item == nil) {
                    continue
                }
                value = item!
            }

            obj.setValue(value, forKey: key)
        }
    }

    internal func deserializeValue(obj: NSObject, properties: Array<CMPropertyInfo>, propertyName: String, value: AnyObject) -> AnyObject? {
        if (!(value is String)) {
            return value
        }

        let stringValue = value as! String

        let property = properties.first({ $0.name == propertyName })!
        let type: AnyClass = NSClassFromString(property.typeInfo.name)!

        if (type == NSData.self) {
            return stringValue.dataUsingEncoding(NSUTF8StringEncoding)
        }

        if (type == NSDate.self) {
            return self.dateFormatter.dateFromString(stringValue)
        }

        if (type == NSUUID.self) {
            return NSUUID(UUIDString: stringValue)
        }

        if (type == NSValue.self) {
            let data = stringValue.dataUsingEncoding(NSUTF8StringEncoding)
            if (data != nil) {
                return NSKeyedUnarchiver.unarchiveObjectWithData(data!)
            }
            return nil
        }

        return stringValue
    }
}
