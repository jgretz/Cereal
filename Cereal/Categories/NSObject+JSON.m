//
// Created by Joshua Gretz on 1/23/15.
// Copyright (c) 2015 TrueFit Solutions. All rights reserved.



#import "NSObject+JSON.h"
#import "JsonCerealizer.h"
#import "NSObject+IOC.h"


@implementation NSObject(JSON)

-(NSString*) toJSON {
    return [[JsonCerealizer object] toString: self];
}

@end