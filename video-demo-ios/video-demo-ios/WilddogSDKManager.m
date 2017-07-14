//
//  WilddogSDKManager.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WilddogSDKManager.h"

@interface WilddogSDKManager()
@property (nonatomic, strong, readwrite) WDGSyncReference *wilddogSyncRootReference;
@property (nonatomic, strong, readwrite) WDGVideoClient *wilddogVideoClient;
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

-(void)registerSDKAppWithName:(NSString *)name
{
    [WDGApp configureWithOptions:[[WDGOptions alloc] initWithSyncURL:[NSString stringWithFormat:@"https://%@.wilddogio.com",name]]];
}

-(WDGVideoClient *)wilddogVideoClient
{
    if(!_wilddogVideoClient){
        _wilddogVideoClient = [[WDGVideoClient alloc] initWithApp:[WDGApp defaultApp]];
    }
    return _wilddogVideoClient;
}

-(WDGSyncReference *)wilddogSyncRootReference
{
    if(!_wilddogSyncRootReference){
        _wilddogSyncRootReference = [[[WDGSync sync] reference] child:@"wilddogVideo"].root;
    }
    return _wilddogSyncRootReference;
}

-(BOOL)reference:(WDGSyncReference *)ref hasChildNode:(NSString *)child
{
    return [[[WDGDataSnapshot new] childSnapshotForPath:ref.description] hasChild:child];
}
@end
