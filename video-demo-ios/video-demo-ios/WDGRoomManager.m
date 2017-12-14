//
//  WDGRoomManager.m
//  video-demo-ios
//
//  Created by wilddog on 2017/12/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGRoomManager.h"
#import "WilddogSDKManager.h"
#import <WilddogSync/WilddogSync.h>
#import "WDGAccount.h"
@interface WDGRoomManager ()
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,assign) WDGSyncHandle onLineHandle;
@end
@implementation WDGRoomManager
- (instancetype)initWithRoomId:(NSString *)roomId complete:(void (^)(NSTimeInterval))complete
{
    self = [super init];
    if (self) {
        self.roomId =roomId;
        [self initRoomComplete:complete];
    }
    return self;
}

-(void)initRoomComplete:(void (^)(NSTimeInterval))complete
{
    [self observeUsersComplete:^(NSTimeInterval interval) {
        if(complete){
            complete(interval);
        }
    }];
}

-(void)loadStartTimeWithTimeInterval:(void (^)(NSTimeInterval))block
{
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:[NSString stringWithFormat:@"room/%@/time",_roomId]] runTransactionBlock:^WDGTransactionResult * _Nonnull(WDGMutableData * _Nonnull currentData) {
        id time = currentData.value;
        if(time && time!= [NSNull null]&&([time isKindOfClass:[NSString class]]||[time isKindOfClass:[NSNumber class]])){
            return [WDGTransactionResult successWithValue:currentData];
        }else{
            [currentData setValue:[WDGServerValue timestamp]];
            return [WDGTransactionResult successWithValue:currentData];
        }
    } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, WDGDataSnapshot * _Nullable snapshot) {
        id time = snapshot.value;
        NSTimeInterval startTime = [time doubleValue];
        if(block)
            block(startTime);
    }];
}

-(void)observeUsersComplete:(void (^)(NSTimeInterval))complete
{
    WDGSyncReference *rootRef = [WilddogSDKManager sharedManager].wilddogSyncRootReference;
    WDGSyncReference *roomRef = [rootRef child:[NSString stringWithFormat:@"room/%@",_roomId]];
    WDGSyncReference *roomUsersRef = [rootRef child:[NSString stringWithFormat:@"room/%@/users",_roomId]];
    if(rootRef!=roomUsersRef){
        __weak typeof(self) WS =self;
        [roomUsersRef observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
            NSDictionary *users = snapshot.value;
            if(users.allKeys.count==0 ||(users.allKeys.count==1 && [[users.allKeys firstObject] isEqualToString:[WDGAccountManager currentAccount].userID])){
                [roomRef removeValue];
            }
            [self loadStartTimeWithTimeInterval:^(NSTimeInterval interval) {
                __strong typeof(WS) self =WS;
                [self observeUser];
                if(complete){
                    complete(interval);
                }
            }];
        }];
    }
}

-(void)observeUser
{
    WDGSyncReference *rootRef = [WilddogSDKManager sharedManager].wilddogSyncRootReference;
    WDGSyncReference *roomUserRef = [rootRef child:[NSString stringWithFormat:@"room/%@/users/%@",self.roomId,[WDGAccountManager currentAccount].userID]];
    self.onLineHandle =[[[WilddogSDKManager sharedManager].wilddogSyncRootReference.root child:@".info/connected"] observeEventType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        if ([snapshot.value boolValue]) {
            [roomUserRef setValue:@{@"name":[WDGAccountManager currentAccount].nickName} withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
                [ref onDisconnectRemoveValueWithCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
                }];
            }];
        }
    }];
}

-(void)closeOperation
{
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference.root child:@".info/connected"] removeObserverWithHandle:_onLineHandle];
    WDGSyncReference *rootRef = [WilddogSDKManager sharedManager].wilddogSyncRootReference;
    WDGSyncReference *roomRef = [rootRef child:[NSString stringWithFormat:@"room/%@",_roomId]];
    WDGSyncReference *roomUsersRef = [roomRef child:@"users"];
    if(roomUsersRef!=roomRef){
         [roomUsersRef observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
            NSMutableDictionary *users = [snapshot.value mutableCopy];
            if(users.allKeys.count==0 ||(users.allKeys.count==1 && [[users.allKeys firstObject] isEqualToString:[WDGAccountManager currentAccount].userID])){
                [roomRef removeValue];
            }else{
                [users removeObjectForKey:[WDGAccountManager currentAccount].userID];
                [roomUsersRef setValue:users];
            }
        }];
    }
}

-(void)dealloc
{
    NSLog(@"roommanager dealloc");
}
@end
