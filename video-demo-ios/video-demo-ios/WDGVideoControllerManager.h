//
//  WDGVideoControllerManager.h
//  video-demo-ios
//
//  Created by han wp on 2017/10/9.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGVideoViewController;
@class WDGVideoViews;
@class WDGVideoControlView;
@class WDGFunctionView;
#import "WDGVideoUserItem.h"
#import <WilddogVideoCall/WDGConversation.h>
@interface WDGVideoControllerManager : NSObject<WDGConversationDelegate>
+(instancetype)sharedManager;
@property (nonatomic, strong) WDGVideoUserItem *oppositeItem;
@property (nonatomic, strong) WDGLocalStream *localStream;
@property (nonatomic, strong) WDGConversation *conversation;
@property (nonatomic,strong) WDGVideoViews *videoView;
@property (nonatomic, strong) WDGVideoControlView *controlView;
@property (nonatomic, strong) WDGFunctionView *functionView;
@property (nonatomic, assign) id<WDGConversationDelegate> conversationDelegate;
@property (nonatomic) CGRect frame;
-(void)showSmallView:(WDGVideoViewController *)videoVC;
-(void)closeConversation;
-(void)closeRoom;
-(BOOL)recordStart;
-(void)recordEndCompletion:(void(^)(BOOL success))completion;

-(void)makeCallToUserItem:(WDGVideoUserItem *)userItem inViewController:(UIViewController *)viewController;
-(void)receiveCallWithConversation:(WDGConversation *)conversation userItem:(WDGVideoUserItem *)userItem inViewController:(UIViewController *)viewController;
-(BOOL)conversationClosed;
@end
