//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import XCTest
import CoreMeta

class CerealKeyTransformTests : XCTestCase {
    func testPascalCaseTransform() {
        let pascal = PascalCaseKeyTransform()
        let test = "test"

        XCTAssert(pascal.transformKey(test) == "Test", "Pascal Case: not properly transforming string")
    }

    func testCaseInsensitiveTransform() {
        let caseInsensitiveTransform = CaseInsensitiveKeyTransform()
        let test = "Color"
        let properties = CMTypeIntrospector(t: Flower.self).properties()

        XCTAssert(caseInsensitiveTransform.propertyName(properties, forKey: test) == "color", "Case Insensitive: not properly transforming string")

    }
}
