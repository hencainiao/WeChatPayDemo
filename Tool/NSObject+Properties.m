//
//  NSObject+Properties.m
//  kuaibov
//
//  Created by Sean Yue on 15/12/8.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

+ (NSArray *)propertiesOfClass:(Class)cls {
    NSMutableArray *propertyArr = [[NSMutableArray alloc] init];
    while (cls != [NSObject class]) {
        uint propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        for (uint i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char* propertyName = property_getName(property);
            if (propertyName) {
                NSString *propName = [NSString stringWithUTF8String:propertyName];
                [propertyArr addObject:propName];
            }
        }
        free(properties);
        cls = [cls superclass];
    }
    return propertyArr;
}

@end
