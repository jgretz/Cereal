Cereal
======

A lightweight serialization framework written in Swift. Supports JSON to objects.

Written for [Truefit](http://www.truefit.io) mainly by [Josh Gretz](http://www.gretzlab.com). You can take a look at [iOS Conf](https://github.com/jgretz/iosconf) to see an example project.

Getting Started
----------
### Overview
Cereal uses the standard [NSJsonSerialization](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSJSONSerialization_Class/) classes to parse the json. What Cereal brings to the party is the ability to work with your objects, not collections. 

Thus:

+ On Serialization, you serialize objects directly instead of converting them manually to dictionaries and arrays.
+ On Deserialization, you are returned objects not dictionaries and arrays

The intent of this framework is to take away the chance of fat fingering string names and reducing repetitive parsing code.

### Installation
#### As a Cocoa Pod
[![Version](https://img.shields.io/cocoapods/v/CoreCereal.svg?style=flat)](http://cocoapods.org/pods/CoreCereal)
[![License](https://img.shields.io/cocoapods/l/CoreCereal.svg?style=flat)](http://cocoapods.org/pods/CoreCereal)
[![Platform](https://img.shields.io/cocoapods/p/CoreCereal.svg?style=flat)](http://cocoapods.org/pods/CoreCereal)

Cereal is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod "CoreCereal"
```

#### As a submodule
+ You can clone this repo down and add it as a submodule to your existing git project. I tend to like to stick all of my submodules in a submodules folder.

```
$ git submodule add https://github.com/jgretz/Cereal.git
```

+ Open your project, and drag Cereal.xcodeproj into your project tree
+ Add Cereal as a linked framework:
	+ Click on your project in the tree
	+ Select the general tab
	+ Scroll down to Linked Frameworks and Libraries
	+ Click on the plus sign
	+ Select Cereal.framework from the list

### NSObject Requirement
Swift has not yet caught up with Objective-C when it comes to introspection (frankly it hasnt even started yet). As such, to pull off the "magic", we need to rely on the introspection methods provided by NSObject. Thus any object that wants to be serialized or deserialized using Cereal needs to derive from NSObject.

### Serializing an object
```
var foo = Foo()
foo.bar = "Hello World"

let serializer:JsonCerealizer = JsonCerealizer.object()
let json = serializer.toString(foo)
```

### Deserializing an object
```
var json = "{\"bar\":\"Hello World\"}"

let serializer:JsonCerealizer = JsonCerealizer.object()
let foo = serializer.create(Foo.self, json) as! Foo
```

By default, Cereal will look at the type of the property and if it is an NSObject, it will loop down and deserialize that object appropriately. The only exception to this logic is for arrays (see more complex situations section below). Cereal also creates objects using CoreMeta, so if the container is configured, your objects will have gone through IOC / DI as well. 

### Tranforms
Often what an given API has named their fields doesn't match your naming scheme (for example, C# APIs like Pascal case, but swift likes Camel Case). Transforms allow you to provide the logic for this mapping. It can be simple like changing cases or can go as far as a logic based map. 

Two transforms come out of the box:

+ PascalCase
+ CaseInsensitive

By default, Cerealizer will use the CaseInsensitive transform.

### Date Formatters
Date formatting is one of the banes of developers existence. C#, Java, Rails, Node, etc, all do it differently. To help you serialize and deserialze dates, Cerealizer exposes an NSDateFormatter property which you can set with the appropriate format for your situation.

By default, Cerealizer will use the format "yyy-MM-dd HH:mm:ss"

The framework provides two other common date formatters as well:

+ Iso8601UtcDateFormatter
+ MicrosoftJsonDateFormatter

### More Complex Serialization Situations
Cereal provides two protocols your class can implement to handle more complex situations. Implementing these protocols will give you granular control over the process.

#### Cerealizable
Implement this protocol when you want to want to control the serialization of an object. It requires three methods:

```
func shouldSerializeProperty(propertyName: String) -> Bool

func overrideSerializeProperty(propertyName: String) -> Bool

func serializeProperty(propertyName: String) -> AnyObject?
```

#### Decerealizable
Implement this protocol when you want to want to control the deserialization of an object. It requires four methods:

```
func typeFor(propertyName: String, value: AnyObject?) -> AnyClass?

func shouldDeserializeProperty(propertyName: String) -> Bool

func overrideDeserializeProperty(propertyName: String, value: AnyObject?) -> Bool

func deserializeProperty(propertyName: String, value: AnyObject?)
```

The typeFor method is probably the method that needs some explanation. The purpose of this method is to handle the case of arrays. Due to the way introspection works, we can't tell the type of the objects in the array. The intent of this method is for you to return the type for each instance.

Other Thoughts
---------
### Branches
I originally wrote this framework in Objective-C. This version can still be found on the [v1-objc](https://github.com/jgretz/Cereal/tree/v1-objc) branch. While using it over the years, my team had the need to support XML in a few situations so we added an XmlCerealizer. I chose not to port this right now, due to the fact we haven't needed it in a while. 

If this is something you need, feel free to reach out or even submit a PR :)

Dependencies
----------

+ [CoreMeta](https://github.com/jgretz/CoreMeta)

License
----------

Copyright 2011 TrueFit Solutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.