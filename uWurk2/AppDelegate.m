//
//  AppDelegate.m
//  uWurk2
//
//  Created by Avery Bonner on 8/31/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2015 Jim Bonner. All rights reserved.
//

#import "AppDelegate.h"
#import "Spinner.h"
#import "UIColor+uWurkColors.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor navBarBackground]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
        
    self.serverAddress = @"http://uwurk.tscserver.com";
    
    return  [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    
    return [self handleOpenURL:url
                forApplication:application
         fromSourceApplication:sourceApplication
                     forWindow:self.window];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    return [self handleOpenURL:url
                forApplication:app
         fromSourceApplication:[options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey]
                     forWindow:self.window];
}

- (BOOL)handleOpenURL:(NSURL *)url forApplication:(UIApplication *)application fromSourceApplication:(nullable NSString *)sourceApplication forWindow:(UIWindow *)window {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:nil];
}

-(NSString *)getDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    return documentsDirectory;
}

- (void)setupUwurkStyle:(UITableView *)tableView cell:(UITableViewCell *)cell
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *separator = [[UIView alloc]init];
    CGRect frame = CGRectZero;
    frame.origin = CGPointMake(cell.frame.origin.x, cell.frame.origin.y + cell.frame.size.height - 1.0);
    frame.size   = CGSizeMake(cell.frame.size.width, 1.0);
    separator.frame = frame;
    
    separator.backgroundColor = [UIColor blueColor];
    separator.alpha = 0.3;
    
    [cell.contentView addSubview:separator];
}

@end
