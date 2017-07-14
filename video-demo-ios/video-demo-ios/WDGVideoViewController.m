//
//  WDGVideoViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoViewController.h"
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
@interface WDGVideoViewController ()<UIAlertViewDelegate,WDGVideoLocalStreamDelegate,WDGVideoConversationDelegate,WDGVideoParticipantDelegate,WDGVideoConversationStatsDelegate>
@property (nonatomic, assign) VideoType myType;
@property (nonatomic, copy) NSString *oppositeID;

@property (nonatomic, strong) WDGVideoControlView *controlView;
@property (nonatomic, strong) WDGVideoViews *videoView;
@property (nonatomic, strong) WDGInfoView *infoView;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic, strong) WDGFileObject *currentRecordFileObject;

@end

@implementation WDGVideoViewController
{
    NSUInteger _recordCurrentTime;
    BOOL _shouldClose;
}
+(instancetype)controllerWithType:(VideoType)type
{
    WDGVideoViewController *videoController = [self new];
//    videoController.oppositeID = OppositeID;
    videoController.myType = type;
    return videoController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.controlView showInView:self.view animate:YES];
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
    BOOL success =[self.conversation startVideoRecording:[NSHomeDirectory() stringByAppendingPathComponent:fileObj.filePath]];
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
    [self.conversation stopVideoRecording];
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

-(WDGVideoLocalStream *)localStream
{
    if(!_localStream){
        WDGVideoLocalStreamOptions *localStreamOptions = [[WDGVideoLocalStreamOptions alloc] init];
//        localStreamOptions.audioOn = YES;
        localStreamOptions.videoOption = [WDGVideoConfig videoConstraintsNum];
        // 创建本地媒体流
        _localStream = [[WDGVideoLocalStream alloc] initWithOptions:localStreamOptions];
        _localStream.delegate =self;
    }
    return _localStream;
}

-(void)setConversation:(WDGVideoConversation *)conversation
{
    _conversation = conversation;
    _conversation.delegate =self;
    _conversation.statsDelegate =self;
    self.localStream = _conversation.localParticipant.stream;
    [_controlView startTimer];
    _infoButton.hidden =NO;
    _recordButton.hidden =NO;
}

- (void)closeRoom
{
    if(_recordCurrentTime>0){
        _shouldClose =YES;
        [self recordEnd];
        return;
    }

    [self.conversation disconnect];
    self.conversation = nil;
    [self.localStream close];
    self.localStream = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)videoControlViewDidHangup:(WDGVideoControlView *)controlView
{
    [self closeRoom];
}

-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidTurned:(BOOL)isFront
{
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

#pragma mark WDGVideoConversationDelegate
/**
 `WDGVideoConversation` 通过调用该方法通知代理当前视频通话有新的参与者加入。
 
 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param participant  代表新的参与者的 `WDGVideoParticipant` 实例。
 */
- (void)conversation:(WDGVideoConversation *)conversation didConnectParticipant:(WDGVideoParticipant *)participant {
    NSLog(@"did connect participant");
    NSLog(@"invoke didConnectParticipant: %@",[NSDate date]);
    participant.delegate = self;
}

- (void)conversation:(WDGVideoConversation *)conversation didDisconnectWithError:(NSError *_Nullable)error {
    NSLog(@"conversation disconnect");
}

/**
 `WDGVideoConversation` 通过调用该方法通知代理当前视频通话某个参与者断开了连接。
 
 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param participant  代表已断开连接的参与者的 `WDGVideoParticipant` 实例。
 */
- (void)conversation:(WDGVideoConversation *)conversation didDisconnectParticipant:(WDGVideoParticipant *)participant {
    [self closeRoom];
}

#pragma mark - WDGVideoParticipantDelegate

/**
 `WDGVideoParticipant` 通过该方法通知代理收到参与者发布的媒体流。
 
 @param participant `WDGVideoParticipant` 对象，代表当前参与者。
 @param stream `WDGVideoRemoteStream` 对象，代表收到的媒体流。
 */
- (void)participant:(WDGVideoParticipant *)participant didAddStream:(WDGVideoRemoteStream *)stream {
    NSLog(@"didAddStream attach remote video View ");
    [self rendarViewWithLocalStream:self.localStream remoteStream:stream];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
}

/**
 `WDGVideoParticipant` 通过该方法通知代理未能收到参与者发布的媒体流。
 
 @param participant `WDGVideoParticipant` 对象，代表当前参与者。
 @param error 错误信息，描述连接失败的原因。
 */
- (void)participant:(WDGVideoParticipant *)participant didFailedToConnectWithError:(NSError *)error {
    
}


/**
 `WDGVideoParticipant` 通过该方法通知代理参与者的媒体流中断。
 
 @param participant `WDGVideoParticipant` 对象，代表当前参与者。
 @param error 错误信息，描述媒体流中断的原因。
 */
- (void)participant:(WDGVideoParticipant *)participant didDisconnectWithError:(NSError *_Nullable)error {
    [_videoView rendarViewWithLocalStream:self.localStream remoteStream:nil];
}

#pragma mark WDGVideoConversationStatsDelegate
- (void)conversation:(WDGVideoConversation *)conversation didUpdateLocalStreamStatsReport:(WDGVideoLocalStreamStatsReport *)report {
    if([_videoView isPresentViewLocalView])
        [_infoView updateInfoWithSize:[NSString stringWithFormat:@"%lu*%lupx",(unsigned long)report.width,(unsigned long)report.height] fps:[NSString stringWithFormat:@"%lufps",(unsigned long)report.FPS] rate:[NSString stringWithFormat:@"%.2fkbps ",report.bitsSentRate/8.f] memory:[NSString stringWithFormat:@"%.2fMB ",report.bytesSent/1024/1024.f] style:PresentViewStyleSend];
}

- (void)conversation:(WDGVideoConversation *)conversation didUpdateRemoteStreamStatsReport:(WDGVideoRemoteStreamStatsReport *)report {
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

-(void)dealloc
{
    [self.view endEditing:YES];
    NSLog(@"视频room已被销毁");
}

@end
