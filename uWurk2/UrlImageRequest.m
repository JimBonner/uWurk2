//
//  UrlImageRequest.m
//  UPMC_HealthBeat-Blog-App
//
//  Created by Allan Rojas on 8/28/15.
//  Copyright (c) 2015 Mobiquity Inc. All rights reserved.
//

#import "UrlImageRequest.h"

NSMutableDictionary *_inflight;
NSCache *_imageCache;

@implementation UrlImageRequest

static int const kIMAGE_REQUEST_CACHE_LIMIT = 100;

- (NSMutableDictionary *)inflight {
    if (!_inflight) {
        _inflight = [NSMutableDictionary dictionary];
    }
    return _inflight;
}

- (NSCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
        _imageCache.countLimit = kIMAGE_REQUEST_CACHE_LIMIT;
    }
    return _imageCache;
}

- (UIImage *)cachedResult {
    UIImage *result = [self.imageCache objectForKey:self.URL.absoluteString];
    if(self.URL && !result) {
        // Try to pull from disk
        NSURL *furl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[self.URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]]];
        result = [UIImage imageWithData:[NSData dataWithContentsOfURL:furl]];
    }
    return result;
}

- (void)startWithCompletion:(CompletionBlock)completion
{
    if (!self.URL.absoluteString) {
        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
        return completion(nil, error);
    }
    
    UIImage *existingImage = [self cachedResult];
    if (existingImage) return completion(existingImage, nil);
    
    NSMutableArray *inflightCompletionBlocks = [self.inflight objectForKey:self.URL.absoluteString];
    if (inflightCompletionBlocks) {
        // a matching request is in flight, keep the completion block to run when we're finished
        [inflightCompletionBlocks addObject:completion];
    } else {
        [self.inflight setObject:[NSMutableArray arrayWithObject:completion] forKey:self.URL.absoluteString];
        
//        [NSURLConnection sendAsynchronousRequest:self queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//        {
//            if (!error) {
//                // build an image, cache the result and run completion blocks for this request
//                UIImage *image = [UIImage imageWithData:data];
//                [self.imageCache setObject:image forKey:self.URL.absoluteString];
//                
//                NSString *storePath= [NSTemporaryDirectory() stringByAppendingPathComponent:[self.URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
//                [UIImagePNGRepresentation(image) writeToFile:storePath atomically:YES];
//                
//                
//                id value = [self.inflight objectForKey:self.URL.absoluteString];
//                [self.inflight removeObjectForKey:self.URL.absoluteString];
//                
//                for (CompletionBlock block in (NSMutableArray *)value) {
//                    block(image, nil);
//                }
//            } else {
//                [self.inflight removeObjectForKey:self.URL.absoluteString];
//                completion(nil, error);
//            }
//        }];
//    }
        
        NSURLSessionDownloadTask *downloadTask =
        [[NSURLSession sharedSession]
         downloadTaskWithURL:self.URL
         completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error)
         {
             if(!error) {
                 UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self.imageCache setObject:image forKey:self.URL.absoluteString];
                     
                     NSString *storePath= [NSTemporaryDirectory() stringByAppendingPathComponent:[self.URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                     [UIImagePNGRepresentation(image) writeToFile:storePath atomically:YES];
                     
                     id value = [self.inflight objectForKey:self.URL.absoluteString];
                     [self.inflight removeObjectForKey:self.URL.absoluteString];
                     
                     for (CompletionBlock block in (NSMutableArray *)value) {
                         block(image, nil);
                     }
                 });
             } else {
                 [self.inflight removeObjectForKey:self.URL.absoluteString];
                 completion(nil, error);
             }
         }];
         [downloadTask resume];
    }
}

@end
