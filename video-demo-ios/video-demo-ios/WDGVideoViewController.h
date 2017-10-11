//
//  WDGVideoViewController.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDGSoundPlayer.h"
#import "WDGVideoUserItem.h"
#import <WilddogVideo/WDGConversation.h>
@class WDGLocalStream;
@class WDGConversation;
@class WDGRemoteStream;
@class WDGVideoViews;
//@protocol WDGConversationDelegate;
typedef NS_ENUM(NSUInteger,VideoType){
    VideoTypeCaller =1,
    VideoTypeReciver
};
@interface WDGVideoViewController : UIViewController<WDGConversationDelegate>
@property (nonatomic, strong) WDGVideoUserItem *oppositeItem;
+(instancetype)controllerWithType:(VideoType)type;
-(void)closeRoom;
@property (nonatomic, strong) WDGLocalStream *localStream;
@property (nonatomic, weak) WDGConversation *conversation;
-(void)rendarViewWithLocalStream:(WDGLocalStream *)localStream remoteStream:(WDGRemoteStream *)remoteStream;
@end
