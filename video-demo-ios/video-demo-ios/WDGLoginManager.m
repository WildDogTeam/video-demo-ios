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

@implementation WDGLoginManager

+(BOOL)hasLogin
{
    return [WDGAccountManager currentAccount].userID.length>0;
}

+(void)loginByTouristComplete:(void (^)())complete
{
    [[WDGAuth auth] signInAnonymouslyWithCompletion:^(WDGUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请在控制台为您的AppID开启匿名登录功能，错误信息: %@", error);
            return;
        }
        WDGAccount *account = [[WDGAccount alloc] init];
        account.userID = user.uid;
        [WDGAccountManager setCurrentAccount:account];
        [[NSNotificationCenter defaultCenter] postNotificationName:WDGAppDidSignInCompleteNotification object:nil];
        complete();
    }];
}
@end
