//
//  NSMutableDictionary+CocoaFix.m
//  uWurk2
//
//  Created by Jim Bonner on 3/30/17.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "NSMutableDictionary+CocoaFix.h"

@implementation NSMutableDictionary (CocoaFix)

- (void)setObjectOrNil:(id)object forKey:(id)key
{
    if (object && key) {
        [self setObject:object forKey:key];
    }    
}

@end
