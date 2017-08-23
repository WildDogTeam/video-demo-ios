//
//  WDGUserInfoRequest.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//
#import "WDGAccount.h"
#import "WDGUserInfoRequest.h"
#import "WDGSimpleConnection.h"
#import "WDGUserDefine.h"
@implementation WDGUserInfoRequest
+(void)requestForUserInfoWithCode:(NSString *)code complete:(void (^)())complete
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WDGWechatAppID,WDGWechatAppSecret,code];
    [WDGSimpleConnection connectionWithUrlString:urlString completion:^(NSDictionary *dict) {
        if(dict){
            NSString *token = dict[@"access_token"];
            if(token){
                NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,WDGWechatAppID];
                [WDGSimpleConnection connectionWithUrlString:urlString completion:^(NSDictionary *dict) {
                    if(dict){
                        NSString *nickName = dict[@"nickname"];
                        NSString *iconUrl = dict[@"headimgurl"];
                        WDGAccount *account = [WDGAccountManager currentAccount];
                        account.nickName = nickName;
                        account.iconUrl =iconUrl;
                        [WDGAccountManager setCurrentAccount:account];
                    }
                    complete();
                }];
            }
        }else{
            complete();
        }
    }];
}
@end
