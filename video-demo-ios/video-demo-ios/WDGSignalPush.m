//
//  WDGSignalPush.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/25.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGSignalPush.h"
#import "WilddogSDKManager.h"
#import "WDGSimpleConnection.h"
#import "WDGUserDefine.h"
@implementation WDGSignalPush
+(void)pushVideoCallWithUid:(NSString *)uid
{
    [[[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:WDGWholeUsers] child:uid] observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        if(snapshot.value){
            [self pushVideoCallWithToken:snapshot.value];
        }
    }];
}

+(void)pushVideoCallWithToken:(NSString *)token
{
    NSString *requestStr = [NSString stringWithFormat:@"https://restapi.getui.com/v1/%@/push_single",WDGGTSDKAppID];
    
    NSDictionary *requestBody = @{@"message": @{
        @"appkey": WDGGTSDKAppKey,
        @"is_offline": @true,
        @"offline_expire_time":@10000000,
        @"msgtype": @"notification"
        },@"notification": @{
            @"style": @{
                @"type": @0,
                @"text": @"text",
                @"title": @"tttt"
                }},@"cid": token,
                                  @"requestid":[NSString stringWithFormat:@"%u",arc4random()]};
    [WDGSimpleConnection connectionWithPostUrlString:requestStr body:requestBody completion:nil];
}

@end
