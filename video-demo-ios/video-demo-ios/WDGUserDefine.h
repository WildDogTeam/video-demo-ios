//
//  WDGUserDefine.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/18.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
//是否开启涂图美颜
FOUNDATION_EXTERN BOOL const WDGAppUseTUSDK;
//是否开启camera360美颜
FOUNDATION_EXTERN BOOL const WDGAppUseCamera360;
//是否开启微信登录
FOUNDATION_EXTERN BOOL const WDGAppUseWechatLogin;
//涂图美颜appkey 需向涂图申请
FOUNDATION_EXTERN NSString const *WDGTUSDKAppKey;
//camera360美颜appkey 需向camera360申请
FOUNDATION_EXTERN NSString const *WDGCamera360AppKey;
//微信登录 需向微信开放平台申请
FOUNDATION_EXTERN NSString const *WDGWechatAppID;
FOUNDATION_EXTERN NSString const *WDGWechatAppSecret;
