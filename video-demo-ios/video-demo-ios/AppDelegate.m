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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import <GTSDK/GeTuiSdk.h> 
#import "WDGSignalPush.h"
@interface AppDelegate ()<WXApiDelegate,GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
@property (nonatomic,copy) NSString *clientId;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // Override point for customization after application launch.WDGAppUseWechatLogin
    if(WDGAppUseWechatLogin)
        [WXApi registerApp:WDGWechatAppID];
    [Fabric with:@[[Crashlytics class]]];
    [self setupWilddogSyncAndAuth];
    [GeTuiSdk startSdkWithAppId:WDGGTSDKAppID appKey:WDGGTSDKAppKey appSecret:WDGGTSDKAppSecret delegate:self];
    [WDGSignalPush prepare];
    // 注册 APNs
    [self registerRemoteNotification];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [WDGLoginManager switchRootViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLoginComplete) name:WDGAppDidSignInCompleteNotification object:nil];
    return YES;
}

-(UIViewController *)topViewController
{
    UITabBarController *tab = self.window.rootViewController;
    UINavigationController *nav = tab.selectedViewController;
    return nav.topViewController;
}

- (void)setupWilddogSyncAndAuth {
    //在野狗后台注册一个Video项目你会得到两个appId 一个是sync的 一个是video的
    // 如果项目中有用到sync的话 可以直接使用syncId 同时你会在后台Sync栏下看到Sync下的数据
    [[WilddogSDKManager sharedManager] registerSDKAppWithSyncId:WDGSyncId videoId:WDGVideoId];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    return  [WXApi handleOpenURL:url delegate:self];

}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
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

- (void)registerRemoteNotification {

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    _clientId =clientId;
    [[WilddogSDKManager sharedManager] registerClientId:clientId];

}

-(void)appLoginComplete
{
    [[WilddogSDKManager sharedManager] registerClientId:_clientId];
}

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    NSLog(@"--------%@--%@--%d--%@",taskId,msgId,offLine,appId);
//    [[[UIAlertView alloc] initWithTitle:@"1231" message:@"1234" delegate:nil cancelButtonTitle:@"hehe" otherButtonTitles: nil] show];
}
@end
