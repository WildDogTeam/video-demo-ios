//
//  WDGVideoViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoViewController.h"
#import "WDGVideoControlView.h"
#import "WDGVideoViews.h"
#import "WDGInfoView.h"
#import <WilddogSync/WilddogSync.h>
#import <WilddogAuth/WilddogAuth.h>
#import <WilddogVideoCall/WilddogVideoCall.h>
#import <WilddogCore/WDGApp.h>
#import "UIView+MBProgressHud.h"
#import <AVFoundation/AVFoundation.h>
#import "WilddogSDKManager.h"
#import "WDGUserInfoView.h"
#import "WDGVideoControllerManager.h"
#import "WDGFunctionView.h"
#import "WDGiPhoneXAdapter.h"
typedef NS_ENUM(NSUInteger,WDGCaptureDevicePosition){
    WDGCaptureDevicePositionFront,
    WDGCaptureDevicePositionBack
};

@interface WDGVideoViewController ()<UIAlertViewDelegate,WDGLocalStreamDelegate,WDGConversationDelegate,WDGConversationStatsDelegate,WDGVideoControl,WDGFunctionViewDelegate>
@property (nonatomic, assign) VideoType myType;
@property (nonatomic, strong) WDGFunctionView *functionView;
@property (nonatomic, strong) WDGUserInfoView *userInfoView;
@property (nonatomic, assign) WDGCaptureDevicePosition capturePosition;
@end

@implementation WDGVideoViewController
{
    NSUInteger _recordCurrentTime;
    BOOL _recording;
    BOOL _shouldClose;
    BOOL _audioSessionShouldSpeaker;
}
+(instancetype)controllerWithType:(VideoType)type
{
    WDGVideoViewController *videoController = nil;
    videoController =[self new];
    videoController.myType = type;
    return videoController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _audioSessionShouldSpeaker =YES;
    self.capturePosition = WDGCaptureDevicePositionFront;
    _recordCurrentTime = 0;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    [self createMyView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
}



-(void)createMyView
{
    WDGVideoViews *videoView = [WDGVideoControllerManager sharedManager].videoView;
    videoView.frame = [UIScreen mainScreen].bounds;
    videoView.viewChange =^(BOOL isLocalViewPresent) {
        [[WDGVideoControllerManager sharedManager].functionView.infoView updateInfoWithSize:@"0*0px" fps:@"0fps" rate:@"0kbps" memory:@"0MB" style:isLocalViewPresent];
    };
    [self.view addSubview:videoView];
    UIView *gradientView = [[UIView alloc] initWithFrame:self.view.bounds];
    gradientView.userInteractionEnabled =NO;
    [self.view addSubview:gradientView];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, videoView.frame.size.width, 250);
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    UIColor *colorOne = [[UIColor blackColor] colorWithAlphaComponent:1];
    UIColor *colorTwo = [[UIColor clearColor] colorWithAlphaComponent:0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    gradient.colors = colors;
    gradient.locations = @[@(-.5),@(0.99)];
    [gradientView.layer addSublayer:gradient];
    
    [[WDGVideoControllerManager sharedManager].controlView showInView:self.view animate:YES];
    [WDGVideoControllerManager sharedManager].controlView.controlDelegate =self;
    
    WDGFunctionView *functionView =[WDGVideoControllerManager sharedManager].functionView;
    functionView.frame = CGRectMake(self.view.frame.size.width-functionView.frame.size.width, 30+WDG_ViewSafeAreInsetsTop, functionView.frame.size.width, functionView.frame.size.height);
    [self.view addSubview:functionView];
    functionView.delegate =self;
    _functionView =functionView;
    
//    悬浮窗
    if(self.conversation){
        [WDGVideoControllerManager sharedManager].conversationDelegate =self;
        self.conversation.statsDelegate =self;
    }
    if(self.myType){
        self.userInfoView = [WDGUserInfoView viewWithName:self.oppositeItem.description imageUrl:self.oppositeItem.faceUrl userType:self.myType==VideoTypeCaller?WDGUserTypeCaller:WDGUserTypeCallee];
        [self.view addSubview:self.userInfoView];
        self.userInfoView.center = CGPointMake(self.view.frame.size.width*.5, self.userInfoView.frame.size.height*.5+50);
    }
    
}

-(void)rendarViewWithLocalStream:(WDGLocalStream *)localStream remoteStream:(WDGRemoteStream *)remoteStream
{
    [[WDGVideoControllerManager sharedManager].videoView rendarViewWithLocalStream:localStream remoteStream:remoteStream];
}

-(void)recordEnd
{
    //停止录制
    __weak typeof(self) WS =self;
    [[WDGVideoControllerManager sharedManager] recordEndCompletion:^(BOOL success) {
        __strong typeof(WS) self =WS;
        if(!success){
            [self.view showHUDWithMessage:@"录屏时间过短，不予保存" hideAfter:1 animate:YES];
        }
        [self checkClose];
    }];
}

-(void)setLocalStream:(WDGLocalStream *)localStream
{
    [WDGVideoControllerManager sharedManager].localStream =localStream;
}

-(WDGLocalStream *)localStream
{
    return [WDGVideoControllerManager sharedManager].localStream;
}

-(void)setConversation:(WDGConversation *)conversation
{
    [WDGVideoControllerManager sharedManager].conversation = conversation;
    [WDGVideoControllerManager sharedManager].conversationDelegate = self;
    [WDGVideoControllerManager sharedManager].conversation.statsDelegate =self;
}

-(WDGConversation *)conversation
{
    WDGConversation *conversation = [WDGVideoControllerManager sharedManager].conversation;
    return conversation;
}

- (void)didSessionRouteChange:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            // 耳机插入
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            [[WDGVideoControllerManager sharedManager].controlView changeAudioSpeakerState:NO];
            _audioSessionShouldSpeaker=NO;
        }
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            [[WDGVideoControllerManager sharedManager].controlView changeAudioSpeakerState:YES];
            _audioSessionShouldSpeaker=YES;
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:_audioSessionShouldSpeaker?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:nil];
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

- (void)closeRoom
{
    if(_recording){
        _shouldClose =YES;
        [self recordEnd];
        return;
    }
    [[WDGVideoControllerManager sharedManager] closeRoom];
    [WDGSoundPlayer stop];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)closeConversation
{
    [[WDGVideoControllerManager sharedManager] closeConversation];
    [self closeRoom];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [WDGVideoControllerManager sharedManager].controlView.hidden?[[WDGVideoControllerManager sharedManager].controlView showInView:self.view animate:YES]:[[WDGVideoControllerManager sharedManager].controlView dismiss];
    UIView *infoview =[WDGVideoControllerManager sharedManager].functionView.infoView;
    if(infoview.superview){
        [[WDGVideoControllerManager sharedManager].functionView hideInfoView];
    }
}

#pragma mark --videoControl

-(void)videoControlView:(WDGVideoControlView *)controlView microphoneDidClick:(BOOL)isOpened
{
    self.localStream.audioEnabled = isOpened;
}

-(void)videoControlView:(WDGVideoControlView *)controlView speakerDidOpen:(BOOL)micphoneOpened
{
    _audioSessionShouldSpeaker = !micphoneOpened;
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:micphoneOpened?AVAudioSessionPortOverrideNone:AVAudioSessionPortOverrideSpeaker error:nil];
}

-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidOpen:(BOOL)cameraOpen
{
    self.localStream.videoEnabled = cameraOpen;
}

-(void)videoControlViewDidHangup:(WDGVideoControlView *)controlView
{
    [self closeConversation];
}

-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidTurned:(BOOL)isFront
{
    self.capturePosition = (self.capturePosition==WDGCaptureDevicePositionFront)?WDGCaptureDevicePositionBack:WDGCaptureDevicePositionFront;
    [[WDGVideoControllerManager sharedManager].videoView showMirrorLocalView:(self.capturePosition ==WDGCaptureDevicePositionFront)];
    [self.localStream switchCamera];
}

#pragma mark WDGConversationDelegate


/**
 * `WDGConversation` 通过调用该方法通知代理视频通话状态发生变化。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param callStatus 表示视频通话的状态，有`Accepted`、`Rejected`、`Busy`、`Timeout` 四种。
 */
- (void)conversation:(WDGConversation *)conversation didReceiveResponse:(WDGCallStatus)callStatus{
    if(callStatus == WDGCallStatusAccepted){
        
        return;
    }
    if(callStatus == WDGCallStatusRejected){
        [self.view showHUDWithMessage:@"对方拒绝了你的邀请" hideAfter:1 animate:YES];
    }else if(callStatus == WDGCallStatusBusy){
        [self.view showHUDWithMessage:@"你所拨打的用户正在通话中，请稍后再拨" hideAfter:1 animate:YES];
    }else if(callStatus == WDGCallStatusTimeout){
        [self.view showHUDWithMessage:@"你所拨打的用户暂时无法接通，请稍后再拨" hideAfter:1 animate:YES];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeRoom];
    });
}

/**
 * `WDGConversation` 通过调用该方法通知代理收到对方传来的媒体流。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param remoteStream `WDGRemoteStream` 实例，表示对方传来的媒体流。
 */
- (void)conversation:(WDGConversation *)conversation didReceiveStream:(WDGRemoteStream *)remoteStream{
    [WDGVideoControllerManager sharedManager].controlView.mode = WDGVideoControlViewMode2;
    [self.userInfoView removeFromSuperview];
    self.userInfoView = nil;
    [self rendarViewWithLocalStream:self.localStream remoteStream:remoteStream];
    self.functionView.hidden =NO;
}

/**
 * `WDGConversation` 通过调用该方法通知代理当前视频通话发生错误而未能建立连接。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param error 错误信息，描述未能建立连接的原因。
 */
- (void)conversation:(WDGConversation *)conversation didFailedWithError:(NSError *)error{
    NSLog(@"%@-----error:%@",NSStringFromSelector(_cmd),error);
    [self closeRoom];
}

- (void)conversationDidClosed:(WDGConversation *)conversation{
    NSLog(@"hantest---closeroom");
    [self closeRoom];
    
}


#pragma mark WDGVideoConversationStatsDelegate
- (void)conversation:(WDGConversation *)conversation didUpdateLocalStreamStatsReport:(WDGLocalStreamStatsReport *)report {
    if([[WDGVideoControllerManager sharedManager].videoView isPresentViewLocalView])
        [[WDGVideoControllerManager sharedManager].functionView.infoView updateInfoWithSize:[NSString stringWithFormat:@"%lu*%lupx",(unsigned long)report.width,(unsigned long)report.height] fps:[NSString stringWithFormat:@"%lufps",(unsigned long)report.FPS] rate:[NSString stringWithFormat:@"%.2fkbps ",report.bitsSentRate/8.f] memory:[NSString stringWithFormat:@"%.2fMB ",report.bytesSent/1024/1024.f] style:PresentViewStyleSend];
}

- (void)conversation:(WDGConversation *)conversation didUpdateRemoteStreamStatsReport:(WDGRemoteStreamStatsReport *)report {
    if(![[WDGVideoControllerManager sharedManager].videoView isPresentViewLocalView])
        [[WDGVideoControllerManager sharedManager].functionView.infoView updateInfoWithSize:[NSString stringWithFormat:@"%lu*%lupx",(unsigned long)report.width,(unsigned long)report.height] fps:[NSString stringWithFormat:@"%lufps",(unsigned long)report.FPS] rate:[NSString stringWithFormat:@"%.2fkbps ",report.bitsReceivedRate/8.f] memory:[NSString stringWithFormat:@"%.2fMB ",report.bytesReceived/1024/1024.f] style:PresentViewStyleReceive];
}

-(BOOL)functionViewRecordSuccessStart:(WDGFunctionView *)functionView recordState:(BOOL)recording
{
    if(recording){
        _recording =YES;
        BOOL success = [[WDGVideoControllerManager sharedManager] recordStart];
        if(!success){
            [self.view showHUDWithMessage:@"录屏初始化失败，请稍后再试" hideAfter:1 animate:YES];
            return NO;
        }
    }else{
        _recording =NO;
        [self recordEnd];
    }
    return YES;
}

-(void)functionViewShowSmallWindowBtnDidClick:(WDGFunctionView *)functionView
{
    [[WDGVideoControllerManager sharedManager] showSmallView:self];
}

-(void)checkClose
{
    _recording =NO;
    if(_shouldClose){
        _shouldClose =NO;
        [self closeRoom];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.userInfoView];
}

-(void)setOppositeItem:(WDGVideoUserItem *)oppositeItem
{
    [WDGVideoControllerManager sharedManager].oppositeItem = oppositeItem;
}

-(WDGVideoUserItem *)oppositeItem
{
    return [WDGVideoControllerManager sharedManager].oppositeItem;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)dealloc
{
    [self.view endEditing:YES];
    NSLog(@"视频room已被销毁");
}

@end
