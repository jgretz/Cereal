//
//  JsonCerealizerTests.swift
//  CerealTests
//
//  Created by Joshua Gretz on 10/30/15.
//  Copyright © 2015 Truefit. All rights reserved.
//

import XCTest

class JsonCerealizerTests: XCTestCase {
    var serializer:JsonCerealizer!
    var flower:Flower!
    var flowerJson:String!
    var dictionaryFlowerJson:String!

    override func setUp() {
        serializer = JsonCerealizer()

        flower = Flower()
        flower.color = "red"
        flower.type = "rose"
        flower.planted = NSDate(timeIntervalSince1970: 0)
        flower.petals = [ Petal(color: "Red"), Petal(color: "Pink"), Petal(color: "White") ]

        flowerJson = "{\"petals\":[{\"color\":\"Red\"},{\"color\":\"Pink\"},{\"color\":\"White\"}],\"type\":\"rose\",\"color\":\"red\",\"planted\":\"1969-12-31 19:00:00\"}"
        dictionaryFlowerJson = "{\"flower\":\(flowerJson),\"another\":\"string\"}"
    }

    //***********
    // To String
    //***********

    func testToStringShouldReturnAnEmptyStringForNonNSObject() {
        let json = serializer.toString(Tree())
        XCTAssert(json == "", "Json Cerealizer: non nsobject serialization not an empty string")
    }

    func testToStringShouldReturnAnEmptyStringForNil() {
        let json = serializer.toString(nil)
        XCTAssert(json == "", "Json Cerealizer: nil serialization not an empty string")
    }

    func testToStringShouldReturnAnEmptyArrayStringForAnEmptyArray() {
        let json = serializer.toString([])
        XCTAssert(json == "[]", "Json Cerealizer: empty array serialization not returning an empty array")
    }

    func testToStringShouldReturnAString() {
        let json = serializer.toString(flower)
        XCTAssert(json.dynamicType == String.self, "Json Cerealizer: serialization not returning a string")
    }

    func testToStringShouldReturnProperString() {
        let json = serializer.toString(flower)
        XCTAssert(json == flowerJson, "Json Cerealizer: serialization not returning proper string")
    }
    
    func testToStringShouldReturnAStringForDictionary() {
        let dict = [
            "flower": flower,
            "another": "string"
        ]
        
        let json = serializer.toString(dict)
        XCTAssert(json == dictionaryFlowerJson, "Json Cerealizer: serialization not returning proper string")
    }

    //*****************
    // To Property Bag
    //*****************

    func testToPropertyBagShouldReturnAnEmptyDictionaryForNil() {
        let bag = serializer.toPropertyBag(nil)
        XCTAssert(bag.count == 0, "Json Cerealizer: property bag not returning an empty dictionary for nil")
    }

    func testToPropertyBagShouldReturnADictionaryWithAnEntryForEachProperty() {
        let bag = serializer.toPropertyBag(flower)
        XCTAssert(bag.count == 4, "Json Cerealizer: property bag not returning a dictionary with the correct number of kvp pairs")
    }

    //***************************
    // To Array of Property Bags
    //***************************

    func testToArrayOfPropertyBagsShouldReturnAnArrayWithAnEntryForEachObject() {
        let list = serializer.toArrayOfPropertyBags([flower,flower])

        XCTAssert(list.count == 2, "Json Cerealizer: to array of property bag not returning a array with the correct number of items")
    }

    //********
    // Create
    //********

    func testCreateShouldReturnNilForAnEmptyString() {
        let obj = serializer.create(Flower.self, fromString: "")
        XCTAssert(obj == nil, "Json Cerealizer: create not returning nil for an empty string")
    }

    func testCreateShouldReturnObjectProperlyInitializedForJson() {
        let obj = serializer.create(Flower.self, fromString: flowerJson)
        XCTAssert(obj != nil && obj!.type == flower.type && obj!.color == flower.color, "Json Cerealizer: create not returning object with proper values set for string")
    }
}
