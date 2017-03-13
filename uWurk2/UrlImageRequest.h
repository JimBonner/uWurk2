//
//  UrlImageRequest.h
//  UPMC_HealthBeat-Blog-App
//
//  Created by Allan Rojas on 8/28/15.
//  Copyright (c) 2015 Mobiquity Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CompletionBlock) (UIImage *, NSError *);

@interface UrlImageRequest : NSMutableURLRequest

- (UIImage *)cachedResult;
- (void)startWithCompletion:(CompletionBlock)completion;

@end
