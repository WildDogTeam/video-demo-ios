//
//  WDGVideoViewController.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDGVideoControlView.h"
@class WDGVideoLocalStream;
@class WDGVideoConversation;
@class WDGVideoClient;
@class WDGVideoRemoteStream;
typedef NS_ENUM(NSUInteger,VideoType){
    VideoTypeCaller,
    VideoTypeReciver
};
@interface WDGVideoViewController : UIViewController<WDGVideoControl>
+(instancetype)controllerWithType:(VideoType)type;
-(void)closeRoom;
@property (nonatomic, strong) WDGVideoLocalStream *localStream;
@property (nonatomic, strong) WDGVideoConversation *conversation;
-(void)rendarViewWithLocalStream:(WDGVideoLocalStream *)localStream remoteStream:(WDGVideoRemoteStream *)remoteStream;
@end
