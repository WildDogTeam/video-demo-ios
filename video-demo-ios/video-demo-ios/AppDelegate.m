//
//  AppDelegate.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/6/21.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "AppDelegate.h"
#import "WDGLoginManager.h"
#import "WDGLoginViewController.h"
#import <WilddogCore/WilddogCore.h>
#import "WilddogSDKManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sleep(1);
    [Fabric with:@[[Crashlytics class]]];

    [self setupWilddogSyncAndAuth];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    if([WDGLoginManager hasLogin]){
        UIViewController *mainViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = mainViewController;
        return YES;
    }
    self.window.rootViewController = [WDGLoginViewController new];
    
    return YES;
}

- (void)setupWilddogSyncAndAuth {
    [[WilddogSDKManager sharedManager] registerSDKAppWithName:@"wang"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
