//
//  WDGVideoControllerManager.m
//  video-demo-ios
//
//  Created by han wp on 2017/10/9.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoControllerManager.h"
#import <UIKit/UIKit.h>
#import "WDGVideoViews.h"
#import "WDGVideoViewController.h"
#import <WilddogVideoCall/WilddogVideoCall.h>
#import "WDGVideoConfig.h"
#import "WDGBeautyManager.h"
#import "WDGVideoControlView.h"
#import "WDGFileManager.h"
#import "WDGVideoTool.h"
#import "WDGConversationsHistory.h"
#import "WDGFunctionView.h"
#import "UIView+MBProgressHud.h"
#import "WDGVideoCallViewController.h"
#import "WDGVideoReceiveViewController.h"
@interface WDGVideoControllerManager()<UIGestureRecognizerDelegate,UIAlertViewDelegate,WDGLocalStreamDelegate>
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *gestureView;
@property (nonatomic) CGPoint center;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic, strong) WDGFileObject *currentRecordFileObject;
@property (nonatomic, assign) NSUInteger recordCurrentTime;
@property (nonatomic, copy) void(^recordCompletion)(BOOL success);
@end

@implementation WDGVideoControllerManager

-(void)makeCallToUserItem:(WDGVideoUserItem *)userItem inViewController:(UIViewController *)viewController
{
    if(self.conversation){
        [viewController.view showHUDWithMessage:@"请结束当前通话再进行拨打" hideAfter:1 animate:YES];
        return;
    }
    WDGVideoCallViewController *cvc =[WDGVideoCallViewController makeCallToUserItem:userItem];
    [viewController presentViewController:cvc animated:YES completion:nil];
}

-(void)receiveCallWithConversation:(WDGConversation *)conversation userItem:(WDGVideoUserItem *)userItem inViewController:(UIViewController *)viewController
{
    if(self.conversation){
        [viewController.view showHUDWithMessage:@"请结束当前通话再进行拨打" hideAfter:1 animate:YES];
        return;
    }
    WDGVideoReceiveViewController *rvc =[WDGVideoReceiveViewController receiveCallWithConversation:conversation userItem:userItem];
    [viewController presentViewController:rvc animated:YES completion:nil];
}

+(instancetype)sharedManager
{
    static WDGVideoControllerManager *_sharedManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

-(void)setFrame:(CGRect)frame
{
    self.contentView.bounds =frame;
    self.videoView.frame =self.contentView.bounds;
    self.gestureView.frame = self.contentView.bounds;
}

-(CGRect)frame
{
    return self.contentView.frame;
}

-(void)setCenter:(CGPoint)center
{
    self.contentView.center = center;
    self.videoView.frame =self.contentView.bounds;
    self.gestureView.frame = self.contentView.bounds;
}

-(CGPoint)center
{
    return self.contentView.center;
}

-(void)setConversation:(WDGConversation *)conversation
{
    _conversation = conversation;
    _conversation.delegate =self;
}

-(void)showSmallView:(WDGVideoViewController *)videoVC
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 160)];
    self.contentView.backgroundColor = [UIColor lightGrayColor];
//    self.videoView = [videoVC.videoView copy];
    self.videoView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.videoView];
    [videoVC dismissViewControllerAnimated:NO completion:nil];
    self.conversationDelegate =nil;
    [[UIApplication sharedApplication].delegate.window addSubview:self.contentView];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.contentView];
    self.gestureView = [[UIView alloc] init];
    self.gestureView.frame = self.contentView.bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnVideoController)];
    [self.gestureView addGestureRecognizer:tap];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.gestureView addGestureRecognizer:panGesture];
    [self.contentView addSubview:self.gestureView];
    
}

-(void)returnVideoController
{
    NSLog(@"返回controller");
    WDGVideoViewController *videoVC = [[WDGVideoViewController alloc] init];
    [[self getTopController] presentViewController:videoVC animated:NO completion:^{
        [self dismissView];
    }];
}

-(UIViewController *)getTopController
{
    UIViewController *topController =[UIApplication sharedApplication].delegate.window.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    CGPoint translation = [panGestureRecognizer translationInView:win];
    CGFloat centerX =self.center.x + translation.x;
    CGFloat minCenterX = self.frame.size.width*.5;
    CGFloat maxCenterX = win.frame.size.width-minCenterX;
    if(centerX<minCenterX) centerX = minCenterX;
    if(centerX>maxCenterX) centerX = maxCenterX;
    CGFloat centerY =self.center.y + translation.y;
    CGFloat minCenterY = self.frame.size.height*.5;
    CGFloat maxCenterY = win.frame.size.height-minCenterY;
    if(centerY<minCenterY) centerY = minCenterY;
    if(centerY>maxCenterY) centerY = maxCenterY;
    self.center = CGPointMake(centerX, centerY);
    [panGestureRecognizer setTranslation:CGPointZero inView:win];
}

-(void)scaleView:(CGFloat)scale
{
    CGPoint center = self.center;
    CGRect rect = CGRectMake(0, 0, self.frame.size.width*scale, self.frame.size.height*scale);
    self.frame = rect;
    self.center =center;
}

-(WDGLocalStream *)localStream
{
    if(!_localStream){
        WDGLocalStreamOptions *localStreamOptions = [[WDGLocalStreamOptions alloc] init];
        //        localStreamOptions.audioOn = YES;
        localStreamOptions.dimension = [WDGVideoConfig videoConstraintsNum];
        // 创建本地媒体流
        _localStream = [WDGLocalStream localStreamWithOptions:localStreamOptions];
        _localStream.delegate =self;
        [self setupBeauty];
    }
    return _localStream;
}


#pragma mark WDGConversationDelegate


/**
 * `WDGConversation` 通过调用该方法通知代理视频通话状态发生变化。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param callStatus 表示视频通话的状态，有`Accepted`、`Rejected`、`Busy`、`Timeout` 四种。
 */
- (void)conversation:(WDGConversation *)conversation didReceiveResponse:(WDGCallStatus)callStatus{
    if(self.conversationDelegate){
        [self.conversationDelegate conversation:conversation didReceiveResponse:callStatus];
        return;
    }
    if(callStatus == WDGCallStatusAccepted){
        return;
    }
    [self closeConversation];
}

/**
 * `WDGConversation` 通过调用该方法通知代理收到对方传来的媒体流。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param remoteStream `WDGRemoteStream` 实例，表示对方传来的媒体流。
 */
- (void)conversation:(WDGConversation *)conversation didReceiveStream:(WDGRemoteStream *)remoteStream{
    if(self.conversationDelegate){
        [self.conversationDelegate conversation:conversation didReceiveStream:remoteStream];
        return;
    }
    [self.videoView rendarViewWithRemoteStream:remoteStream];
}

/**
 * `WDGConversation` 通过调用该方法通知代理当前视频通话发生错误而未能建立连接。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param error 错误信息，描述未能建立连接的原因。
 */
- (void)conversation:(WDGConversation *)conversation didFailedWithError:(NSError *)error{
    if(self.conversationDelegate){
        [self.conversationDelegate conversation:conversation didFailedWithError:error];
        return;
    }
    [self closeConversation];
}

- (void)conversationDidClosed:(WDGConversation *)conversation{
    if(self.conversationDelegate){
        [self.conversationDelegate conversationDidClosed:conversation];
        return;
    }
    [self closeConversation];
}

-(void)closeConversation
{
    if(_recordCurrentTime>0)
        [self recordEndCompletion:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.conversation close];
        self.conversation = nil;
        [self.localStream close];
        self.localStream =nil;
    });
    [self.functionView removeFromSuperview];
    self.functionView = nil;
    [self addHistoryItem];
    [self.videoView removeFromSuperview];
    self.videoView = nil;
    [self.controlView removeFromSuperview];
    self.controlView =nil;
    [self dismissView];
}

-(void)dismissView
{
    [self.gestureView removeFromSuperview];
    self.gestureView = nil;

    [self.contentView removeFromSuperview];
    self.contentView = nil;
}

-(void)addHistoryItem
{
    WDGConversationItem *item =[[WDGConversationItem alloc] init];
    item.uid = self.oppositeItem.uid;
    item.nickname =self.oppositeItem.nickname;
    item.faceUrl = self.oppositeItem.faceUrl;
    item.conversationTime = [[WDGVideoControllerManager sharedManager].controlView showTime];
    item.finishTime = [[NSDate date] timeIntervalSince1970];
    [WDGConversationsHistory addHistoryItem:item];
}

-(CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    return [[WDGBeautyManager sharedManager] proccessPixelBuffer:pixelBuffer]?:pixelBuffer;
}

-(void)setupBeauty
{
    [WDGBeautyManager sharedManager].option = [[NSClassFromString([NSString stringWithFormat:@"WDG%@Option",[WDGVideoConfig beautyPlan]]) alloc] init];
}

-(WDGVideoViews *)videoView
{
    if(!_videoView){
        _videoView = [[WDGVideoViews alloc] init];
    }
    return _videoView;
}

-(WDGVideoControlView *)controlView
{
    if(!_controlView){
        _controlView = [[WDGVideoControlView alloc] init];
        _controlView.hidden =YES;
        _controlView.oppoSiteName =self.oppositeItem.description;
    }
    return _controlView;
}

-(BOOL)recordStart
{
    //    开始录制
    WDGFileObject *fileObj = [WDGFileObject new];
    fileObj.fileName = [WDGVideoTool recordCurrentTime];
    fileObj.filePath = [NSString stringWithFormat:@"Library/%@.mp4",fileObj.fileName];
    _currentRecordFileObject =fileObj;
    _recordCurrentTime = 0;
    BOOL success =[self.conversation startLocalRecording:[NSHomeDirectory() stringByAppendingPathComponent:fileObj.filePath]];
    if(!success){
        return NO;
    }
    [self timerBegin];
    return YES;
}

-(void)timerBegin
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)updateRecordTime
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _recordCurrentTime++;
        self.functionView.timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",_recordCurrentTime/60,_recordCurrentTime%60];
    });
}

-(void)recordEndCompletion:(void(^)(BOOL success))completion
{
    //停止录制
    [self.conversation stopLocalRecording];
    _currentRecordFileObject.recordTime = _recordCurrentTime;
    [self timerClose];
    [self save:completion];
}

-(void)timerClose
{
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

-(void)save:(void(^)(BOOL success))completion
{
    if(_recordCurrentTime<=10){
        if(completion)
            completion(NO);
        [[WDGFileManager sharedManager] deleteFileWithObject:_currentRecordFileObject];
        return;
    }
    _recordCurrentTime = 0;
    _recordCompletion =completion;
    [self showRenameAlertView];
}

-(void)showRenameAlertView
{
    UIAlertView *renameAlert = [[UIAlertView alloc] initWithTitle:@"存储录制文件" message:nil delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"存储", nil];
    renameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [renameAlert textFieldAtIndex:0].text = _currentRecordFileObject.fileName;
    [renameAlert show];
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
    if(_recordCompletion)
        _recordCompletion(YES);
}

-(WDGFunctionView *)functionView
{
    if(!_functionView){
        _functionView = [[WDGFunctionView alloc] init];
    }
    return _functionView;
}



@end
