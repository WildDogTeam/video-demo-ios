//
//  WDGBlackManager.m
//  video-demo-ios
//
//  Created by han wp on 2017/10/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGBlackManager.h"
#import "WDGVideoUserItem.h"
#define WDGBlackListKey @"com.wilddog.blackList"

NSString *const WDGBlackListAddUserNotification = @"com.wilddog.WDGBlackListAddUserNotification";
NSString *const WDGBlackListRemoveUserNotification =@"com.wilddog.WDGBlackListRemoveUserNotification";

@implementation WDGBlackManager
static NSMutableArray<WDGVideoUserItem *> *_blackList;

+(BOOL)addBlack:(WDGVideoUserItem *)userItem
{
    [self initBlackList];
    if([self checkIncludeBlackItem:userItem]){
        return NO;
    }
    [_blackList addObject:userItem];
    [self writeToFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:WDGBlackListAddUserNotification object:userItem];
    return YES;
}

+(BOOL)checkIncludeBlackItem:(WDGVideoUserItem *)blackItem
{
    if(!_blackList.count) return NO;
    for (WDGVideoUserItem *item in _blackList) {
        if([item.uid isEqualToString:blackItem.uid]){
            return YES;
        }
    }
    return NO;
}

+(NSArray<WDGVideoUserItem *> *)blackList
{
    [self initBlackList];
    return _blackList;
}

+(void)deleteBlack:(WDGVideoUserItem *)userItem
{
    [self initBlackList];
    [_blackList removeObject:userItem];
    [self writeToFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:WDGBlackListRemoveUserNotification object:userItem];
}

+(void)initBlackList
{
    if(!_blackList){
        NSData *blackData = [[NSUserDefaults standardUserDefaults] objectForKey:WDGBlackListKey];
        NSArray *blackList = [NSKeyedUnarchiver unarchiveObjectWithData:blackData];
        if(!blackList){
            _blackList = [NSMutableArray array];
        }else{
            _blackList = [NSMutableArray arrayWithArray:blackList];
        }
    }
}

+(void)writeToFile
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_blackList] forKey:WDGBlackListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
