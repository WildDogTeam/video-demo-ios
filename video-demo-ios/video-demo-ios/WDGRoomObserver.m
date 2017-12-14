//
//  WDGRoomObserver.m
//  video-demo-ios
//
//  Created by wilddog on 2017/12/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGRoomObserver.h"
#import <WilddogSync/WilddogSync.h>
#import "WilddogSDKManager.h"
#import "WDGAccount.h"
#define WDGObserveRoomNotCloseNormal @"com.wilddog.WDGObserveRoomNotCloseNormal"

@interface WDGRoomObserver()
@property (nonatomic,strong) NSMutableArray *rooms;
@end

@implementation WDGRoomObserver
- (instancetype)init
{
    self = [super init];
    if (self) {
        _rooms = [NSMutableArray array];
    }
    return self;
}

-(NSMutableArray *)rooms
{
    NSMutableArray *rooms = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:WDGObserveRoomNotCloseNormal]];
    return rooms;
}

-(void)synchronizeRooms
{
    [[NSUserDefaults standardUserDefaults] setObject:_rooms forKey:WDGObserveRoomNotCloseNormal];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)roomOpen:(NSString *)roomId
{
    [self.rooms addObject:roomId];
    [self synchronizeRooms];
}

-(void)roomClose:(NSString *)roomId
{
    [self.rooms removeObject:roomId];
    [self synchronizeRooms];
}

-(void)handleObserver
{
    if(self.rooms.count){
        [self removeUidForRooms];
    }
    [self.rooms removeAllObjects];
    [self synchronizeRooms];
}

-(void)removeUidForRooms
{
    for (NSString *roomId in _rooms) {
        WDGSyncReference *rootRef = [WilddogSDKManager sharedManager].wilddogSyncRootReference;
        WDGSyncReference *ref = [rootRef child:[NSString stringWithFormat:@"room/%@/users/%@",roomId,[WDGAccountManager currentAccount].userID]];
        if(rootRef==ref){
            continue;
        }
        [ref removeValue];
    }
}

-(void)clearObserver
{
    _rooms =nil;
    [self synchronizeRooms];
}

@end
