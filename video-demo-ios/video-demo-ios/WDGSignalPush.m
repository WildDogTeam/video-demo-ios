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
#import "NSString+Sha256.h"
@implementation WDGSignalPush
static NSString *_auth_token;

+(void)prepare
{
    NSString *requestStr = [NSString stringWithFormat:@"https://restapi.getui.com/v1/%@/auth_sign",WDGGTSDKAppID];
    NSNumber *timestamp = @((long)([[NSDate date] timeIntervalSince1970]*1000));
    NSString *GTSignStr = [NSString stringWithFormat:@"%@%@%@",WDGGTSDKAppKey,timestamp,WDGGTSDKMasterSecret];
    NSDictionary *requestBody = @{@"appkey": WDGGTSDKAppKey,
                                  @"sign":[GTSignStr sha256],
                                  @"timestamp":timestamp
                                        };
    
    [WDGSimpleConnection connectionWithPostUrlString:requestStr requestHeader:@{@"Content-Type": @"application/json"} body:requestBody completion:^(NSDictionary *dict) {
        if(dict){
            _auth_token = [dict objectForKey:@"auth_token"];
        }
    }];

}

+(void)pushVideoCallWithUid:(NSString *)uid
{
    [[[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:WDGWholeUsers] child:uid] observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        if(snapshot.value){
            [self pushVideoCallWithClientId:snapshot.value];
        }
    }];
}

+(void)pushVideoCallWithClientId:(NSString *)clientId
{
    if(_auth_token.length ==0) return;
    NSString *requestStr = [NSString stringWithFormat:@"https://restapi.getui.com/v1/%@/push_single",WDGGTSDKAppID];
    NSString *requestId = [NSString stringWithFormat:@"%@",@((int)([[NSDate date] timeIntervalSince1970]*10000))];
    NSDictionary *requestBody = @{@"message": @{
        @"appkey": WDGGTSDKAppKey,
        @"is_offline": @(YES),
        @"msgtype": @"transmission"
        },@"transmission":@{
            @"transmission_type":@(NO),
            @"transmission_content":@"this is the transmission_content"
            },@"push_info": @{
                @"aps": @{
                    @"alert": @{
                        @"title": @"xxxx",
                        @"body": @"xxxxx"
                    },
                    @"autoBadge": @"+1",
                    @"content-available": @1
                    }},@"cid": clientId,
                                  @"requestid":requestId};
    [WDGSimpleConnection connectionWithPostUrlString:requestStr requestHeader:@{@"Content-Type": @"application/json",@"authtoken":_auth_token} body:requestBody completion:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
    }];
}

@end
