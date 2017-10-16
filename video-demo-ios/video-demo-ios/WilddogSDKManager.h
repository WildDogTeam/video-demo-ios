//
//  WilddogSDKManager.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WilddogSync/WilddogSync.h>
#import <WilddogCore/WilddogCore.h>
#import <WilddogVideoCall/WilddogVideoCall.h>
#import <WilddogAuth/WDGAuth.h>

#define WDGWholeUsers @"wholeUsers"
#define WDGOnlineUsers @"users"

@interface WilddogSDKManager : NSObject
+(instancetype)sharedManager;
-(void)registerSDKAppWithSyncId:(NSString *)syncId videoId:(NSString *)videoId;
-(void)registerClientId:(NSString *)clientId;
@property (nonatomic, strong, readonly) WDGSyncReference *wilddogSyncRootReference;
@property (nonatomic, strong, readonly) WDGVideoCall *wilddogVideo;
@property (nonatomic, strong, readonly) WDGAuth *wilddogVideoAuth;
-(void)goOffLine;
-(void)goOnLine;
@end
