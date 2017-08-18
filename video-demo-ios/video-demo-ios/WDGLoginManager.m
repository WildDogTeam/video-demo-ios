//
//  WDGLoginManager.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGLoginManager.h"
#import <WilddogAuth/WilddogAuth.h>
#import "WDGAccount.h"
#import "WDGNotifications.h"
#import "WilddogSDKManager.h"
#import "WDGLoginViewController.h"
@implementation WDGLoginManager

+(BOOL)hasLogin
{
    return [WDGAccountManager currentAccount].userID.length>0;
}

+(void)loginByTouristComplete:(void (^)())complete
{
    [[WilddogSDKManager sharedManager] goOnLine];
    [[WilddogSDKManager sharedManager].wilddogVideoAuth signInAnonymouslyWithCompletion:^(WDGUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请在控制台为您的AppID开启匿名登录功能，错误信息: %@", error);
            return;
        }
        

        [user getTokenWithCompletion:^(NSString * _Nullable idToken, NSError * _Nullable error) {
            if(error){
                NSLog(@"[WilddogVideo][Error] WDGVideoErrorInvalidAuthArgument : failed to get token of user %@ with error: %@", user, error);
                NSAssert(error == nil, @"[WilddogVideo][Error] WDGVideoErrorInvalidAuthArgument : failed to get token of user %@ with error: %@", user, error);
                return ;
            }
            [[WilddogSDKManager sharedManager].wilddogVideo setToken:idToken];
            WDGAccount *account = [[WDGAccount alloc] init];
            account.userID = user.uid;
            account.token =idToken;
            [WDGAccountManager setCurrentAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:WDGAppDidSignInCompleteNotification object:nil];
            complete();
        }];
    }];
}

+(void)logOut
{
    [WDGAccountManager setCurrentAccount:nil];
    [[WilddogSDKManager sharedManager] goOffLine];
    [UIApplication sharedApplication].delegate.window.rootViewController=[self switchRootViewController];
}

+(UIViewController *)switchRootViewController
{
    
    if([self hasLogin]){
        UIViewController *mainViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        return mainViewController;
    }
    return [WDGLoginViewController new];
}


@end
