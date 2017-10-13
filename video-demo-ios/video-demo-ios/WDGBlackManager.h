//
//  WDGBlackManager.h
//  video-demo-ios
//
//  Created by han wp on 2017/10/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WDGVideoUserItem;
extern NSString *const WDGBlackListAddUserNotification;
extern NSString *const WDGBlackListRemoveUserNotification;

@interface WDGBlackManager : NSObject
+(BOOL)addBlack:(WDGVideoUserItem *)userItem;
+(NSArray<WDGVideoUserItem *> *)blackList;
+(void)deleteBlack:(WDGVideoUserItem *)userItem;
@end
