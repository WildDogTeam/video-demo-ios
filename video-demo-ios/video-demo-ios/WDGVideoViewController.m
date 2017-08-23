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
#import <WilddogVideo/WilddogVideo.h>
#import <WilddogCore/WDGApp.h>
#import "WDGFileManager.h"
#import "WDGVideoTool.h"
#import "WDGVideoConfig.h"
#import "UIView+MBProgressHud.h"
#import <AVFoundation/AVFoundation.h>
#import "WDGBeautyManager.h"
#import "WilddogSDKManager.h"
#import "WDGConversationsHistory.h"
#import "WDGUserInfoView.h"
typedef NS_ENUM(NSUInteger,WDGCaptureDevicePosition){
    WDGCaptureDevicePositionFront,
    WDGCaptureDevicePositionBack
};

@interface WDGVideoViewController ()<UIAlertViewDelegate,WDGLocalStreamDelegate,WDGConversationDelegate,WDGVideoDelegate,WDGConversationStatsDelegate,WDGVideoControl>
@property (nonatomic, assign) VideoType myType;

@property (nonatomic, strong) WDGVideoControlView *controlView;
@property (nonatomic, strong) WDGVideoViews *videoView;
@property (nonatomic, strong) WDGInfoView *infoView;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic, strong) WDGUserInfoView *userInfoView;
@property (nonatomic, strong) WDGFileObject *currentRecordFileObject;
@property (nonatomic, assign) WDGCaptureDevicePosition capturePosition;
@end

@implementation WDGVideoViewController
{
    NSUInteger _recordCurrentTime;
    BOOL _shouldClose;
}
+(instancetype)controllerWithType:(VideoType)type
{
    WDGVideoViewController *videoController = [self new];
    videoController.myType = type;
    return videoController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.capturePosition = WDGCaptureDevicePositionFront;
    _recordCurrentTime = 0;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    [self setupBeauty];
    [self createMyView];
}

-(void)setupBeauty
{
    [WDGBeautyManager sharedManager].option = [[NSClassFromString([NSString stringWithFormat:@"WDG%@Option",[WDGVideoConfig beautyPlan]]) alloc] init];
}

-(void)createMyView
{
    __weak typeof(self) WS =self;
    WDGVideoViews *videoView =[[WDGVideoViews alloc] initWithViewChange:^(BOOL isLocalViewPresent) {
        __strong typeof(WS)self =WS;
        [self.infoView updateInfoWithSize:@"0*0px" fps:@"0fps" rate:@"0kbps" memory:@"0MB" style:isLocalViewPresent];
    }];
    _videoView =videoView;
    [self.view addSubview:videoView];
    [self.controlView showInView:self.view animate:YES];

    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoButton.frame =CGRectMake(self.view.frame.size.width -33-15, 33, 33, 33);
    [infoButton setImage:[UIImage imageNamed:@"说明"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    infoButton.hidden =YES;
    _infoButton =infoButton;
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame =CGRectMake(CGRectGetMinX(_infoButton.frame), CGRectGetMaxY(infoButton.frame)+21, 33, 33);
    [recordButton setImage:[UIImage imageNamed:@"录制文件-未点击"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"录制文件-点击"] forState:UIControlStateSelected];
    [recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
    _recordButton =recordButton;
    recordButton.hidden =YES;

    self.userInfoView = [WDGUserInfoView viewWithName:self.oppositeItem.description imageUrl:self.oppositeItem.faceUrl userType:self.myType==VideoTypeCaller?WDGUserTypeCaller:WDGUserTypeCallee];
    [self.view addSubview:self.userInfoView];
    self.userInfoView.center = CGPointMake(self.view.frame.size.width*.5, self.userInfoView.frame.size.height*.5+50);
}

-(void)rendarViewWithLocalStream:(WDGVideoLocalStream *)localStream remoteStream:(WDGVideoRemoteStream *)remoteStream
{
    [_videoView rendarViewWithLocalStream:localStream remoteStream:remoteStream];
}

-(void)showInfoView
{
    [self.view addSubview:self.infoView];
    self.infoButton.hidden = YES;
    self.recordButton.hidden = YES;
    if(_recordCurrentTime){
        self.timeLabel.hidden =YES;
    }
}

-(void)hideInfoView
{
    [self.infoView removeFromSuperview];
    self.infoView =nil;
    self.infoButton.hidden = NO;
    self.recordButton.hidden = NO;
    if(_recordCurrentTime){
        self.timeLabel.hidden =NO;
    }
}

-(void)startRecord
{
    _recordButton.selected =!_recordButton.selected;
    if(_recordButton.selected){
        [self changeRecordBtnSelectAppearance];
        [self recordStart];
    }else{
        [self returnRecordBtnAppearance];
        [self recordEnd];
    }
}

-(void)recordStart
{
//    开始录制
    WDGFileObject *fileObj = [WDGFileObject new];
    fileObj.fileName = [WDGVideoTool recordCurrentTime];
    fileObj.filePath = [NSString stringWithFormat:@"Library/%@.mp4",fileObj.fileName];
    _currentRecordFileObject =fileObj;
    BOOL success =[self.conversation startLocalRecording:[NSHomeDirectory() stringByAppendingPathComponent:fileObj.filePath]];
    if(!success){
        [self.view showHUDWithMessage:@"录屏初始化失败，请稍后再试" hideAfter:1 animate:YES];
        _recordButton.selected =NO;
        [self returnRecordBtnAppearance];
        return;
    }
    self.timeLabel.text =@"00:00:00";
    [self timerBegin];
}

-(void)changeRecordBtnSelectAppearance
{
    [_recordButton setBackgroundColor:[UIColor colorWithWhite:1. alpha:.8]];
    _recordButton.layer.cornerRadius = _recordButton.frame.size.width*.5;
    [_recordButton setClipsToBounds:YES];
}

-(void)returnRecordBtnAppearance
{
    [_recordButton setBackgroundColor:[UIColor clearColor]];
    _recordButton.layer.cornerRadius = 0;
    [_recordButton setClipsToBounds:NO];
}

-(void)recordEnd
{
    //停止录制
    [self.conversation stopLocalRecording];
    _currentRecordFileObject.recordTime = _recordCurrentTime;
    [self timerClose];
    [_timeLabel removeFromSuperview];
    _timeLabel = nil;
    [self save];
}

-(void)timerBegin
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecordLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)timerClose
{
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

-(void)save
{
    if(_recordCurrentTime<=10){
        NSLog(@"录屏时间过短，不予保存");
        [self.view showHUDWithMessage:@"录屏时间过短，不予保存" hideAfter:1 animate:YES];
        //删除本地视频
        [[WDGFileManager sharedManager] deleteFileWithObject:_currentRecordFileObject];
        [self checkClose];
        return;
    }
    [self showRenameAlertView];
}

-(void)showRenameAlertView
{
    UIAlertView *renameAlert = [[UIAlertView alloc] initWithTitle:@"存储录制文件" message:nil delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"存储", nil];
    renameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [renameAlert textFieldAtIndex:0].text = _currentRecordFileObject.fileName;
    [renameAlert show];
}

-(void)updateRecordLabel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _recordCurrentTime++;
        self.timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",_recordCurrentTime/60/60,_recordCurrentTime/60%60,_recordCurrentTime%60];
    });
}

-(WDGVideoControlView *)controlView
{
    if(!_controlView){
        _controlView = [[WDGVideoControlView alloc] init];
        _controlView.controlDelegate =self;
        _controlView.hidden =YES;
        _controlView.oppoSiteName =self.oppositeItem.description;
    }
    return _controlView;
}

-(WDGInfoView *)infoView
{
    if(!_infoView){
        CGFloat infoViewWidth = 150;
        CGFloat infoViewHeight =100;
        _infoView = [[WDGInfoView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - infoViewWidth -15, 33, infoViewWidth, infoViewHeight)];
    }
    return _infoView;
}

-(UILabel *)timeLabel
{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont fontWithName:@"pingfang sc" size:12];
        _timeLabel.frame = CGRectMake(CGRectGetMinX(self.recordButton.frame)-160, CGRectGetMinY(self.recordButton.frame), 150, CGRectGetHeight(self.recordButton.frame));
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(WDGLocalStream *)localStream
{
    if(!_localStream){
        WDGLocalStreamOptions *localStreamOptions = [[WDGLocalStreamOptions alloc] init];
//        localStreamOptions.audioOn = YES;
        localStreamOptions.dimension = [WDGVideoConfig videoConstraintsNum];
        // 创建本地媒体流
        _localStream = [[WilddogSDKManager sharedManager].wilddogVideo localStreamWithOptions:localStreamOptions];
        _localStream.delegate =self;
    }
    return _localStream;
}

-(void)setConversation:(WDGConversation *)conversation
{
    _conversation = conversation;
    _conversation.delegate =self;
    _conversation.statsDelegate =self;
}

- (void)closeRoom
{
    [WDGSoundPlayer stop];
    if(_recordCurrentTime>0){
        _shouldClose =YES;
        [self recordEnd];
        return;
    }

    [self.conversation close];
    _conversation = nil;
    [self.localStream close];
    _localStream = nil;
    
    WDGConversationItem *item =[[WDGConversationItem alloc] init];
    item.uid = self.oppositeItem.uid;
    item.nickname =self.oppositeItem.nickname;
    item.faceUrl = self.oppositeItem.faceUrl;
    item.conversationTime = [_controlView showTime];
    item.finishTime = [[NSDate date] timeIntervalSince1970];
    
    [WDGConversationsHistory addHistoryItem:item];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.controlView.hidden?[_controlView showInView:self.view animate:YES]:[_controlView dismiss];
    if(_infoView){
        [self hideInfoView];
    }
}

#pragma mark --videoControl

-(void)videoControlView:(WDGVideoControlView *)controlView microphoneDidClick:(BOOL)isOpened
{
    self.localStream.audioEnabled = isOpened;
}

-(void)videoControlView:(WDGVideoControlView *)controlView speakerDidOpen:(BOOL)micphoneOpened
{
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:micphoneOpened?AVAudioSessionPortOverrideNone:AVAudioSessionPortOverrideSpeaker error:nil];
}

-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidOpen:(BOOL)cameraOpen
{
    self.localStream.videoEnabled = cameraOpen;
}

-(void)videoControlViewDidHangup:(WDGVideoControlView *)controlView
{
    [self closeRoom];
}

-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidTurned:(BOOL)isFront
{
    self.capturePosition = (self.capturePosition==WDGCaptureDevicePositionFront)?WDGCaptureDevicePositionBack:WDGCaptureDevicePositionFront;
    [_videoView showMirrorLocalView:(self.capturePosition ==WDGCaptureDevicePositionFront)];
    [self.localStream switchCamera];
}

#pragma mark --alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        //删除操作
        [[WDGFileManager sharedManager] deleteFileWithObject:_currentRecordFileObject];
    }else{
        //rename操作
        if([alertView textFieldAtIndex:0].text.length){
            _currentRecordFileObject.fileName =[alertView textFieldAtIndex:0].text;
        }
        [[WDGFileManager sharedManager] saveFile:_currentRecordFileObject withName:_currentRecordFileObject.fileName overWrite:YES];
    }
    //    是否没有关闭录制就要退出视频聊天界面
    [self checkClose];
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
    _controlView.mode = WDGVideoControlViewMode2;
    [self.userInfoView removeFromSuperview];
    self.userInfoView = nil;
    [self rendarViewWithLocalStream:self.localStream remoteStream:remoteStream];
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
    [self closeRoom];
}


#pragma mark WDGVideoConversationStatsDelegate
- (void)conversation:(WDGConversation *)conversation didUpdateLocalStreamStatsReport:(WDGLocalStreamStatsReport *)report {
    if([_videoView isPresentViewLocalView])
        [_infoView updateInfoWithSize:[NSString stringWithFormat:@"%lu*%lupx",(unsigned long)report.width,(unsigned long)report.height] fps:[NSString stringWithFormat:@"%lufps",(unsigned long)report.FPS] rate:[NSString stringWithFormat:@"%.2fkbps ",report.bitsSentRate/8.f] memory:[NSString stringWithFormat:@"%.2fMB ",report.bytesSent/1024/1024.f] style:PresentViewStyleSend];
}

- (void)conversation:(WDGConversation *)conversation didUpdateRemoteStreamStatsReport:(WDGRemoteStreamStatsReport *)report {
    if(![_videoView isPresentViewLocalView])
        [_infoView updateInfoWithSize:[NSString stringWithFormat:@"%lu*%lupx",(unsigned long)report.width,(unsigned long)report.height] fps:[NSString stringWithFormat:@"%lufps",(unsigned long)report.FPS] rate:[NSString stringWithFormat:@"%.2fkbps ",report.bitsReceivedRate/8.f] memory:[NSString stringWithFormat:@"%.2fMB ",report.bytesReceived/1024/1024.f] style:PresentViewStyleReceive];
}

-(CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    return [[WDGBeautyManager sharedManager] proccessPixelBuffer:pixelBuffer]?:pixelBuffer;
}

-(void)checkClose
{
    _recordCurrentTime =0;
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

-(void)dealloc
{
    [self.view endEditing:YES];
    NSLog(@"视频room已被销毁");
}

@end
