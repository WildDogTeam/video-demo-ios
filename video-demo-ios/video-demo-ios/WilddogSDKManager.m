//
//  WilddogSDKManager.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WilddogSDKManager.h"
#import "WDGAccount.h"
#import <WilddogVideoBase/WDGVideoInitializer.h>
//#define WilddogAppForVideo @"com.wilddog.app.video"
//#define WilddogAppForSync @"com.wilddog.app.sync"

@interface WilddogSDKManager()
@property (nonatomic, strong, readwrite) WDGSyncReference *wilddogSyncRootReference;
@property (nonatomic, strong, readwrite) WDGVideo *wilddogVideo;
@property (nonatomic, strong, readwrite) WDGAuth *wilddogVideoAuth;
@property (nonatomic, strong) WDGSync *wilddogSync;
@end

@implementation WilddogSDKManager
+(instancetype)sharedManager
{
    static WilddogSDKManager *_sdkManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sdkManager = [[self alloc] init];
    });
    return _sdkManager;
}

-(void)registerSDKAppWithSyncId:(NSString *)syncId videoId:(NSString *)videoId
{
    [WDGApp configureWithOptions:[[WDGOptions alloc] initWithSyncURL:[NSString stringWithFormat:@"https://%@.wilddogio.com",syncId]]];
    NSString *token =[WDGAccountManager currentAccount].token;
    [[WDGVideoInitializer sharedInstance] configureWithVideoAppId:videoId token:token?:@""];
}

-(WDGVideo *)wilddogVideo
{
    if(!_wilddogVideo){
        _wilddogVideo = [WDGVideo sharedVideo];
        
    }
    return _wilddogVideo;
}

-(WDGAuth *)wilddogVideoAuth
{
    if(!_wilddogVideoAuth){
        _wilddogVideoAuth = [WDGAuth auth];
    }
    return _wilddogVideoAuth;
}

-(WDGSync *)wilddogSync
{
    if(!_wilddogSync){
        _wilddogSync = [WDGSync sync];
    }
    return _wilddogSync;
}

-(WDGSyncReference *)wilddogSyncRootReference
{
    if(!_wilddogSyncRootReference){
        _wilddogSyncRootReference = [self.wilddogSync reference];
    }
    return _wilddogSyncRootReference;
}

-(BOOL)reference:(WDGSyncReference *)ref hasChildNode:(NSString *)child
{
    return [[[WDGDataSnapshot new] childSnapshotForPath:ref.description] hasChild:child];
}

-(void)goOffLine
{
    [self.wilddogVideo stop];
    [self.wilddogVideoAuth signOut:nil];
    [self.wilddogSync goOffline];
}

-(void)goOnLine
{
    [self.wilddogVideo start];
    [self.wilddogSync goOnline];
}

-(void)registerClientId:(NSString *)clientId;
{
    if(clientId.length && [WDGAccountManager currentAccount].userID.length){
        [[[self.wilddogSyncRootReference child:WDGWholeUsers] child:[WDGAccountManager currentAccount].userID] setValue:clientId];
    }
}
@end
