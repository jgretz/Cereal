//
// Created by Joshua Gretz on 11/3/15.
// Copyright (c) 2015 Truefit. All rights reserved.
//

import Foundation
import CoreMeta

extension NSObject {
    func toJson() -> String {
        let cerializer:JsonCerealizer = JsonCerealizer.object()
        return cerializer.toString(self)
    }

    class func fromJson<T>(json:String) -> T {
        let cerializer:JsonCerealizer = JsonCerealizer.object()
        return cerializer.create(self, fromString: json) as! T
    }

    func toPropertyBag() -> AnyObject {
        let cerializer:JsonCerealizer = JsonCerealizer.object()
        return cerializer.toPropertyBag(self)
    }
}
