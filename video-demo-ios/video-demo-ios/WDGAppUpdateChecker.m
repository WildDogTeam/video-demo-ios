//
//  WDGAppUpdateChecker.m
//  video-demo-ios
//
//  Created by wilddog on 2017/12/14.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGAppUpdateChecker.h"
#import "WilddogSDKManager.h"
@implementation WDGAppUpdateChecker
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%87%8E%E7%8B%97%E8%A7%86%E9%A2%91%E9%80%9A%E8%AF%9D/id1278669326?mt=8"]];
    exit(0);
}

+ (void)check
{
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"WDGAppVersionForceUpdate"] observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        if(snapshot.value){
            id value = snapshot.value;
            if([value isKindOfClass:[NSDictionary class]]){
                NSString *appNewVersion = [value valueForKey:@"appversion"];
                NSInteger forceUpdate = [[value valueForKey:@"forceupdate"] integerValue];
                if(forceUpdate==1){
                    [self forceUpdate:appNewVersion];
                }
            }
            
        }
    }];
}

+(void)forceUpdate:(NSString *)appNewVersion
{
    BOOL forceUpdate =NO;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSArray *appVersionArr = [appVersion componentsSeparatedByString:@"."];
    NSArray *appNewVersionArr = [appNewVersion componentsSeparatedByString:@"."];
    NSInteger count = appVersionArr.count>appNewVersionArr.count?appNewVersionArr.count:appVersionArr.count;
    for (int i=0; i<count; i++) {
        if([appNewVersionArr[i] intValue]>[appVersionArr[i] intValue]){
            forceUpdate =YES;
            break;
        }
    }
    if(!forceUpdate){
        if(appNewVersionArr.count>appVersionArr.count){
            forceUpdate =YES;
        }
    }
    if(forceUpdate){
        [self showForceUpdateAlert];
    }
}

+(void)showForceUpdateAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"应用有新版本，请升级" delegate:[self checker] cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+(instancetype)checker
{
    static WDGAppUpdateChecker *_checker= nil;
    _checker =[[WDGAppUpdateChecker alloc] init];
    return _checker;
}

@end
