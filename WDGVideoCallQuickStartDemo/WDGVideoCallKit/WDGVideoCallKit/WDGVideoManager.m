//
//  WDGVideoManager.m
//  WDGVideoKit
//
//  Created by han wp on 2017/10/12.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoManager.h"
#import "WDGVideoConversation_Internal.h"
#import "WDGVideoUser.h"
#import <WilddogVideoBase/WilddogVideoBase.h>
#import "WDGVideoControllerSelector.h"
#import <WilddogVideoCall/WilddogVideoCall.h>
#import "WDGVideoConversation.h"
#import "WDGVideoControllerConfig.h"

@interface WDGVideoManager()<WDGVideoCallDelegate,WDGConversationDelegate,WDGConversationStatsDelegate,WDGVideoCallDelegate>
@property (nonatomic,copy) NSString *videoId;
@end

@implementation WDGVideoManager
static WDGVideoManager *_videoManager =nil;
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _videoManager = [[self alloc] init];
    });
    return _videoManager;
}

-(void)makeCallToUser:(WDGVideoUser *)user
{
    WDGVideoConversation *videoConversation =[[WDGVideoConversation alloc] init];
    videoConversation.config.oppositeUid =user.uid;
    videoConversation.conversation = [[WDGVideoCall sharedInstance] callWithUid:videoConversation.config.oppositeUid localStream:videoConversation.localStream data:nil];
    videoConversation.conversation.delegate =self;
    WDGVideoControllerConfig *controllerConfig = [WDGVideoControllerConfig new];
    controllerConfig.videoConversation =videoConversation;
    controllerConfig.videoControllerType = WDGVideoControllerTypeCaller;
    [videoConversation videoStateChange:WDGVideoConversationStatePending finishReason:WDGVideoFinishReasonNormal];
    [WDGVideoControllerSelector showVideoControllerWithConfig:controllerConfig];
    _videoConversation =videoConversation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)configWithOption:(WDGVideoCallOption *)option
{
    [[WDGVideoInitializer sharedInstance] configureWithVideoAppId:option.videoId token:option.token];
    [WDGVideoCall sharedInstance].delegate =self;
    
}

- (void)wilddogVideoCall:(WDGVideoCall *)videoCall didReceiveCallWithConversation:(WDGConversation *)conversation data:(NSString * _Nullable)data
{
    WDGVideoConversation *videoConversation =[[WDGVideoConversation alloc] init];
    _videoConversation =videoConversation;
    videoConversation.conversation = conversation;
    videoConversation.conversation.delegate =self;
    videoConversation.config.oppositeUid = conversation.remoteUid;
    WDGVideoControllerConfig *controllerConfig = [WDGVideoControllerConfig new];
    controllerConfig.videoConversation =videoConversation;
    controllerConfig.videoControllerType = WDGVideoControllerTypeReceiver;
    [WDGVideoControllerSelector showVideoControllerWithConfig:controllerConfig];
    [videoConversation videoStateChange:WDGVideoConversationStateIncoming finishReason:WDGVideoFinishReasonNormal];
}

- (void)wilddogVideoCall:(WDGVideoCall *)videoCall didFailWithTokenError:(NSError *)error
{
    NSLog(@"%@-----error:%@",NSStringFromSelector(_cmd),error);
    [self.videoConversation videoStateChange:WDGVideoConversationStateFinishCalling finishReason:WDGVideoFinishReasonError];
}

- (void)conversation:(WDGConversation *)conversation didReceiveResponse:(WDGCallStatus)callStatus
{
    WDGVideoConversationState state = WDGVideoConversationStateNormal;
    WDGVideoFinishReason finishReason = WDGVideoFinishReasonNormal;
    switch (callStatus) {
        case WDGCallStatusAccepted:
            NSLog(@"Call Accepted!");
            state = WDGVideoConversationStateConnecting;
            self.videoConversation.isConnecting =YES;
            break;
        case WDGCallStatusRejected:
            NSLog(@"Call Rejected!");
            state = WDGVideoConversationStateFinishCalling;
            finishReason = WDGVideoFinishReasonRejectedByOppositeSide;
            break;
        case WDGCallStatusBusy:
            NSLog(@"Call Busy!");
            state = WDGVideoConversationStateFinishCalling;
            finishReason = WDGVideoFinishReasonBusy;
            break;
        case WDGCallStatusTimeout:
            NSLog(@"Call Timeout!");
            state = WDGVideoConversationStateFinishCalling;
            finishReason = WDGVideoFinishReasonNoAnswerByOppositeSide;
            break;
        default:
            break;
    }
    [self.videoConversation videoStateChange:state finishReason:finishReason];
}

- (void)conversation:(WDGConversation *)conversation didReceiveStream:(WDGRemoteStream *)remoteStream
{
    NSLog(@"receive stream %@ from user %@", remoteStream, conversation.remoteUid);
    self.videoConversation.remoteStream =remoteStream;
    [self.videoConversation videoStateChange:WDGVideoConversationStateOnCalling finishReason:WDGVideoFinishReasonNormal];
}

- (void)conversation:(WDGConversation *)conversation didFailedWithError:(NSError *)error
{
    NSLog(@"WDGConversation Error:%@",error);
    if(error.code == WDGVideoErrorConversationTimeOut){
        [self.videoConversation videoStateChange:WDGVideoConversationStateFinishCalling finishReason:_videoConversation.isConnecting?WDGVideoFinishReasonOutOfTimeForReConnection:WDGVideoFinishReasonOutOfTimeForAnswer];
    }else{
        [self.videoConversation videoStateChange:WDGVideoConversationStateFinishCalling finishReason:WDGVideoFinishReasonError];
    }
}

- (void)conversationDidClosed:(WDGConversation *)conversation
{
    WDGVideoFinishReason reason = WDGVideoFinishReasonNormal;
    if(_videoConversation.config.videoFinishReason == WDGVideoFinishReasonNormal){
        if(_videoConversation.isConnecting){
            reason = WDGVideoFinishReasonHungupByOppositeSide;
        }else{
            reason = WDGVideoFinishReasonCancelByOppositeSide;
        }
    }else{
        reason =_videoConversation.config.videoFinishReason;
    }
    [self.videoConversation videoStateChange:WDGVideoConversationStateFinishCalling finishReason:reason];
}



@end
