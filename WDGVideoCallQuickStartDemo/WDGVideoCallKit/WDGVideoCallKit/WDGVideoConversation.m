//
//  WDGVideoConversation.m
//  WDGVideoKit
//
//  Created by han wp on 2017/10/12.
//  Copyright © 2017年 wilddog. All rights reserved.
//
#import "WDGVideoConversation_Internal.h"
#import <WilddogVideoBase/WilddogVideoBase.h>
#import <AVFoundation/AVFoundation.h>

@interface WDGVideoConversationConfig()
@property (nonatomic,assign,readwrite) NSTimeInterval currentTime;

@end

@implementation WDGVideoConversationConfig
@end

@interface WDGVideoConversation()
@property (nonatomic,strong) NSTimer *calculateTimer;
@end

@implementation WDGVideoConversation

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self videoStateChange:WDGVideoConversationStateNormal finishReason:WDGVideoFinishReasonNormal];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
        self.shouldLoudspeaker =YES;
    }
    return self;
}

-(void)setShouldLoudspeaker:(BOOL)shouldLoudspeaker
{
    _shouldLoudspeaker =shouldLoudspeaker;
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:_shouldLoudspeaker?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:nil];
}

- (void)didSessionRouteChange:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];

    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            // 耳机插入
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        }
            break;

        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:self.shouldLoudspeaker?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:nil];
        }
            break;

        case AVAudioSessionRouteChangeReasonCategoryChange:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:self.shouldLoudspeaker?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:nil];
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}


-(WDGVideoConversationConfig *)config
{
    if(!_config){
        WDGVideoConversationConfig *config = [WDGVideoConversationConfig new];
        config.currentTime = 0;
        config.videoConversationState = WDGVideoConversationStateNormal;
        config.videoFinishReason = WDGVideoFinishReasonNormal;
        _config = config;
    }
    return _config;
}

-(WDGLocalStream *)localStream
{
    if(!_localStream){
        WDGLocalStreamOptions *option = [[WDGLocalStreamOptions alloc] init];
        option.dimension = WDGVideoDimensions360p;
        _localStream = [WDGLocalStream localStreamWithOptions:option];
    }
    return _localStream;
}

-(void)videoStateChange:(WDGVideoConversationState)state finishReason:(WDGVideoFinishReason)finishReason
{
    if(state!=0)
        self.config.videoConversationState =state;
    self.config.videoFinishReason = finishReason;
//    如果在这里崩溃请检查视频挂断后是否有内存泄漏 导致该类没有正常销毁 
    if([self.statusDelegate respondsToSelector:@selector(videoStatusDidChanged:)]){
        [self.statusDelegate videoStatusDidChanged:self];
    }
    if(self.config.videoConversationState == WDGVideoConversationStateFinishCalling){
        if ([self.conversationDelegate respondsToSelector:@selector(videoConversationDidClosed:)]) {
            [self videoCallTimeInvalidate];
            [self.conversationDelegate videoConversationDidClosed:self];
        }
    }
    if(self.config.videoConversationState == WDGVideoConversationStateOnCalling){
        [self videoCallTimeStart];
        if ([self.conversationDelegate respondsToSelector:@selector(remoteStreamDidAdded:)]) {
            [self.conversationDelegate remoteStreamDidAdded:self];
        }
    }
}

-(void)videoCallTimeStart
{
    _calculateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculate) userInfo:nil repeats:YES];
}

-(void)videoCallTimeInvalidate
{
    [_calculateTimer invalidate];
    _calculateTimer =nil;
}

-(void)calculate
{
    self.config.currentTime++;
}

-(void)accept
{
    self.isConnecting =YES;
    [self videoStateChange:WDGVideoConversationStateConnecting finishReason:WDGVideoFinishReasonNormal];
    [self.conversation acceptWithLocalStream:self.localStream];
}

-(void)rejectImmediately
{
    self.isConnecting =YES;
    [self videoStateChange:WDGVideoConversationStateFinishCalling finishReason:WDGVideoFinishReasonReject];
    [self.conversation reject];
}

-(void)reject
{
    self.isConnecting =YES;
    [self videoStateChange:0 finishReason:WDGVideoFinishReasonReject];
    [self.conversation reject];
}

-(BOOL)startRecording:(NSString *)recordPath
{
    return [self.conversation startLocalRecording:recordPath];
}

-(void)stopRecording
{
    [self.conversation stopLocalRecording];
}

-(void)closeImmediately
{
    if(self.isConnecting){
        [self videoStateChange:WDGVideoConversationStateFinishCalling finishReason:WDGVideoFinishReasonHungupByMySelf];
    }else{
        [self videoStateChange:WDGVideoConversationStateFinishCalling finishReason:WDGVideoFinishReasonCancel];
    }
    [self.conversation close];
}

-(void)close
{
    if(self.isConnecting){
        [self videoStateChange:0 finishReason:WDGVideoFinishReasonHungupByMySelf];
    }else{
        [self videoStateChange:0 finishReason:WDGVideoFinishReasonCancel];
    }
    [self.conversation close];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"conversation dealloc");
}
@end
