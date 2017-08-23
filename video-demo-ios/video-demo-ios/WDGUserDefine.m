//
//  WDGUserDefine.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/23.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGUserDefine.h"

//各级小开关
//涂图美颜
#define WDGUserUseTUSDK                 1
//camera360美颜
#define WDGUserUseCamera360             1
//微信登录
#define WDGUserUseWechatLogin           1



#if 1 
/**
    这里需要用户向第三方平台申请拿到相应的信息之后填写并配合各级开关打开或关闭相应的功能 如果用户没有按照正常流程操作(比如未申请appkey及打开开关等) 则可能出现未知错误或者闪退 此处作者只验证了正常情况未发现异常
 */
//总开关
#define WDGAppUseBelow               0
//涂图注册
NSString const *WDGTUSDKAppKey = @"";
//camera360注册
NSString const *WDGCamera360AppKey = @"";
//微信开放平台注册 需要在野狗个人中心身份验证下打开微信登录 并填入相应信息
NSString const *WDGWechatAppID = @"";
NSString const *WDGWechatAppSecret = @"";
#else
#endif

BOOL const WDGAppUseTUSDK = (WDGAppUseBelow && WDGUserUseTUSDK);
BOOL const WDGAppUseCamera360 = (WDGAppUseBelow && WDGUserUseCamera360);
BOOL const WDGAppUseWechatLogin = (WDGAppUseBelow && WDGUserUseWechatLogin);
