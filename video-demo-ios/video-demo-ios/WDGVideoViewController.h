//
//  WDGVideoViewController.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDGSoundPlayer.h"
@class WDGLocalStream;
@class WDGConversation;
@class WDGRemoteStream;
@protocol WDGConversationDelegate;
typedef NS_ENUM(NSUInteger,VideoType){
    VideoTypeCaller,
    VideoTypeReciver
};
@interface WDGVideoViewController : UIViewController<WDGConversationDelegate>
@property (nonatomic, copy) NSString *oppositeID;
+(instancetype)controllerWithType:(VideoType)type;
-(void)closeRoom;
@property (nonatomic, strong) WDGLocalStream *localStream;
@property (nonatomic, strong) WDGConversation *conversation;
-(void)rendarViewWithLocalStream:(WDGLocalStream *)localStream remoteStream:(WDGRemoteStream *)remoteStream;
@end
