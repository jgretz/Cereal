//
// Created by Joshua Gretz on 1/23/15.
// Copyright (c) 2015 TrueFit Solutions. All rights reserved.



#import "NSObject+Cereal.h"
#import "Cerealizer.h"
#import "NSObject+IOC.h"

@implementation NSObject(Cereal)

-(id) toPropertyBag {
    return [[Cerealizer object] toObject: self];
}

@end