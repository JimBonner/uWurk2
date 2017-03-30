//
//  NSMutableDictionary+NSMutableDictionary_CocoaFix.h
//  uWurk2
//
//  Created by Jim Bonner on 3/30/17.
//  Copyright © 2017 Jim Bonner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (CocoaFix)

- (void)setObjectOrNil:(id)object forKey:(id)key;

@end
