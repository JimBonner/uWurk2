//
//  AppDelegate.h
//  uWurk2
//
//  Created by Avery Bonner on 8/31/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *user;
@property (strong, nonatomic) NSString *documentsDirectory;
@property (strong, nonatomic) NSString *serverAddress;

@property CGSize screenSize;

-(NSString *)getDocumentsDirectory;

@end

