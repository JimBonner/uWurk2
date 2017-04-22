//
//  UIColor+KNGColors.m
//  Kum-n-GoLoyaltyApp
//
//  Created by Pratikbhai Patel on 9/21/15.
//  Copyright (c) 2015 Mobiquity, Inc. All rights reserved.
//

#import "UIColor+uWurkColors.h"
#import "ColorUtils.h"

NSString * const navBarBackground   = @"222222";
NSString * const KNGDarkString      = @"231f20";
NSString * const KNGDarkGrayString  = @"414141";
NSString * const KNGGrayString      = @"808284";
NSString * const KNGLightGrayString = @"bcbdc0";
NSString * const KNGBlueString      = @"0382b8";
NSString * const KNGYellowString    = @"f18e00";
NSString * const KNGBrownString     = @"a37227";
NSString * const KNGGreenString     = @"5db24e";
NSString * const KNGHyperLinkBlue   = @"0e82b8";
NSString * const KNGDropShadowGray  = @"d5d5d5";

@implementation UIColor (KNGColors)

+ (UIColor *)navBarBackground {
    return [self colorWithString:navBarBackground];
}

+ (UIColor *)KNGBlue {
    return [self colorWithString:KNGBlueString];
}

+ (UIColor *)KNGYellow {
    return [self colorWithString:KNGYellowString];
}

+ (UIColor *)KNGBrown {
    return [self colorWithString:KNGBrownString];
}

+ (UIColor *)KNGDark {
    return [self colorWithString:KNGDarkString];
}

+ (UIColor *)KNGDarkGray {
    return [self colorWithString:KNGDarkGrayString];
}

+ (UIColor *)KNGGray {
    return [self colorWithString:KNGGrayString];
}

+ (UIColor *)KNGLightGray {
    return  [self colorWithRed:0.851f green:0.847f blue:0.847f alpha:1.0f];
}

+ (UIColor *)KNGDisabled {
    return [self colorWithWhite:0.0f alpha:0.2f];
}

+ (UIColor *)KNGGreen {
    return [self colorWithString:KNGGreenString];
}

+ (UIColor *)KNGHyperLinkBlue {
    return [self colorWithString:KNGHyperLinkBlue];
}

+ (UIColor *)KNGDropShadowGray {
    return [self colorWithString:KNGDropShadowGray];
}



@end
