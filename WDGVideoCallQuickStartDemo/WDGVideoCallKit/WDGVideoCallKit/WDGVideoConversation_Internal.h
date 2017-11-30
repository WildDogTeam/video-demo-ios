//
//  WDGVideoConversation_Internal.h
//  WDGVideoKit
//
//  Created by han wp on 2017/10/12.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoConversation.h"
#import <WilddogVideoCall/WDGConversation.h>
@protocol WDGVideoConversationDelegate <NSObject>
-(void)videoConversationDidClosed:(WDGVideoConversation *)videoConversation;
-(void)remoteStreamDidAdded:(WDGVideoConversation *)videoConversation;
@end

@interface WDGVideoConversation()
@property (nonatomic,strong) WDGLocalStream *localStream;
@property (nonatomic,strong) WDGRemoteStream *remoteStream;
@property (nonatomic,assign) id<WDGVideoConversationStatusDelegate> statusDelegate;
@property (nonatomic,assign) id<WDGVideoConversationDelegate> conversationDelegate;
@property (nonatomic,assign) id<WDGConversationStatsDelegate> statsDelegate;
@property (nonatomic,strong) WDGConversation *conversation;
@property (nonatomic,assign) BOOL isConnecting;
-(void)videoStateChange:(WDGVideoConversationState)state finishReason:(WDGVideoFinishReason)finishReason;


-(void)close;
-(void)accept;
-(void)reject;
-(BOOL)startRecording:(NSString *)recordPath;
-(void)stopRecording;
@end
