//
// Created by Joshua Gretz on 11/1/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

open class CerealizerBase: NSObject, Cerealizer {
    open var dateFormatter: DateFormatter!
    open var serializeKeyTransform: CerealKeyTransform?
    open var deserializeKeyTransform: CerealKeyTransform?

    public override init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        self.deserializeKeyTransform = CaseInsensitiveKeyTransform()
    }

    //***********
    // Serialize
    //***********

    open func toString(_ obj: AnyObject?) -> String {
        return ""
    }

    open func toArrayOfPropertyBags(_ array: Array<NSObject>) -> Array<Dictionary<String, AnyObject>> {
        var returnArray = Array<Dictionary<String, AnyObject>>()
        for obj in array {
            returnArray.append(self.toPropertyBag(obj))
        }

        return returnArray
    }

    open func toPropertyBag(_ obj: NSObject?) -> Dictionary<String, AnyObject> {
        var bag = Dictionary<String, AnyObject>()
        guard let obj = obj
            else { return bag }
        
        if obj is NSDictionary {
            return serializeValue(obj) as! Dictionary<String, AnyObject>
        }

        let properties = CMTypeIntrospector(t: type(of: obj)).properties()
        for property in properties {
            let key = self.serializeKeyTransform?.transformKey(property.name) ?? property.name
            
            if (obj is Cerealizable) {
                let cerealizable = obj as! Cerealizable
                if (!cerealizable.shouldSerializeProperty(property.name)) {
                    continue
                }

                if (cerealizable.overrideSerializeProperty(property.name)) {
                    bag[key] = cerealizable.serializeProperty(property.name)
                    continue
                }
            }

            let value = obj.value(forKey: property.name)
            if (value == nil) {
                continue
            }

            bag[key] = serializeValue(value! as AnyObject)
        }

        return bag
    }

    internal func serializeValue(_ value: AnyObject) -> AnyObject {
        // handle straight return cases
        if (value is String || value is NSNumber) {
            return value
        }

        if (value is NSValue) {
            return NSKeyedArchiver.archivedData(withRootObject: value).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as AnyObject
        }

        if (value is Date) {
            return self.dateFormatter.string(from: value as! Date) as AnyObject
        }

        if (value is UUID) {
            return (value as! UUID).uuidString as AnyObject
        }

        if (value is Data) {
            return (value as! Data).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as AnyObject
        }

        // collection types
        if (value is Array<NSObject>) {
            return self.toArrayOfPropertyBags(value as! Array<NSObject>) as AnyObject
        }

        if let sourceDict = value as? [String: NSObject] {
            var returnDict = [String: NSObject]()
            for key in sourceDict.keys {
                if let dictValue = sourceDict[key] {
                    returnDict[key] = serializeValue(dictValue) as? NSObject
                }
            }

            return returnDict as AnyObject
        }

        if (value is Set<NSObject>) {
            let sourceSet = value as! Set<NSObject>
            var returnArray = Array<NSObject>()
            for sourceItem in sourceSet {
                returnArray.append(self.toPropertyBag(sourceItem) as NSObject)
            }

            return returnArray as AnyObject
        }

        // object type
        if (value is NSObject) {
            return self.toPropertyBag(value as? NSObject) as AnyObject
        }

        // default
        return value
    }

    //*************
    // Deserialize
    //*************

    open func create(_ type: AnyClass, fromString: String) -> AnyObject? {
        return nil
    }

    open func create(_ type: AnyClass, fromObject: AnyObject) -> AnyObject? {
        if (fromObject is Array<Dictionary<String, NSObject>>) {
            let dataArray: Array<Dictionary<String, NSObject>> = fromObject as! Array<Dictionary<String, NSObject>>

            var array = Array<NSObject>()
            for data in dataArray {
                let obj = NSObject.objectForType(type)
                fillObject(obj, data: data)

                array.append(obj)
            }

            return array as AnyObject?
        } else if (fromObject is Dictionary<String, NSObject>) {
            let obj = NSObject.objectForType(type)
            
            if obj is NSDictionary {
                return fromObject
            }
            
            fillObject(obj, data: fromObject as! Dictionary<String, NSObject>)

            return obj
        }

        return nil
    }

    internal func fillObject(_ obj: NSObject, data: Dictionary<String, AnyObject>) {
        let properties = CMTypeIntrospector(t: type(of: obj)).properties()

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
            
            // ensure that key is a property on the object
            if (!properties.contains { $0.name == key }) {
                continue
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

                    value = targetArray as AnyObject?
                }
            } else {
                let item = deserializeValue(obj, properties: properties, propertyName: key, value: value!)
                if (item == nil) {
                    continue
                }
                value = item! as AnyObject!
            }

            if (value == nil || value is NSNull) {
                continue
            }

            obj.setValue(value, forKey: key)
        }
    }

    internal func deserializeValue(_ obj: NSObject, properties: Array<CMPropertyInfo>, propertyName: String, value: AnyObject) -> Any? {
        if (!(value is String)) {
            return value
        }

        let stringValue = value as! String

        let property = properties.first({ $0.name == propertyName })!
        let type: AnyClass = NSClassFromString(property.typeInfo.name)!

        if (type == Data.self || type == Data?.self || type == NSData.self) {
            return stringValue.data(using: String.Encoding.utf8, allowLossyConversion: false)
        }

        if (type == Date.self || type == Date?.self || type == NSDate.self) {
            return self.dateFormatter.date(from: stringValue)
        }

        if (type == UUID.self) {
            return NSUUID(uuidString: stringValue)
        }

        if (type == NSValue.self) {
            let data = stringValue.data(using: String.Encoding.utf8)
            if (data != nil) {
                return NSKeyedUnarchiver.unarchiveObject(with: data!)
            }
            return nil
        }

        return stringValue
    }
}
