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
#import "WDGUserDefine.h"
#import <WXApi.h>
#import "WDGNotifications.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if(WDGAppUseWechatLogin)
        [WXApi registerApp:WDGWechatAppID];
    [Fabric with:@[[Crashlytics class]]];
    [self setupWilddogSyncAndAuth];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [WDGLoginManager switchRootViewController];
    return YES;
}

- (void)setupWilddogSyncAndAuth {
    //在野狗后台注册一个Video项目你会得到两个appId 一个是sync的 一个是video的
    // 如果项目中有用到sync的话 可以直接使用syncId 同时你会在后台Sync栏下看到Sync下的数据
    [[WilddogSDKManager sharedManager] registerSDKAppWithSyncId:@"wd0231007108blsomo" videoId:@"wd6029736988xhigqo"];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return  [WXApi handleOpenURL:url delegate:self];

}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        __weak typeof(self) WS= self;
        
        if(resp.errCode == -2){
            [[NSNotificationCenter defaultCenter] postNotificationName:WDGAppSigninWechatDidcancelledByUser object:nil];
            return;
        }
        
        [WDGLoginManager loginByWechatWithCode:authResp.code complete:^{
            WS.window.rootViewController =[WDGLoginManager switchRootViewController];
        }];
    }
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
