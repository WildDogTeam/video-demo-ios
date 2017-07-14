//
//  WilddogSDKManager.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WilddogSync/WilddogSync.h>
#import <WilddogVideo/WDGVideoClient.h>
#import <WilddogCore/WilddogCore.h>
@interface WilddogSDKManager : NSObject
+(instancetype)sharedManager;
-(void)registerSDKAppWithName:(NSString *)name;
-(BOOL)reference:(WDGSyncReference *)ref hasChildNode:(NSString *)child;
@property (nonatomic, strong, readonly) WDGSyncReference *wilddogSyncRootReference;
@property (nonatomic, strong, readonly) WDGVideoClient *wilddogVideoClient;
@end
