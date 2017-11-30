//
//  WDGVideoCallViewController.m
//  WDGVideoKit
//
//  Created by han wp on 2017/11/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoCallViewController.h"
#import <WilddogVideoBase/WilddogVideoBase.h>
#import <WilddogVideoCall/WilddogVideoCall.h>
#import "WDGVideoConversation_Internal.h"
#import "WDGVideoControllerConfig.h"

NSString *WDGGetVideoStatus(WDGVideoConversationState status){
    switch (status) {
        case WDGVideoConversationStateNormal:
            return @"初始化状态";
            break;
        case WDGVideoConversationStatePending:
            return @"拨号状态";
            break;
        case WDGVideoConversationStateIncoming:
            return @"来电状态";
            break;
        case WDGVideoConversationStateConnecting:
            return @"建立连接状态";
            break;
        case WDGVideoConversationStateOnCalling:
            return @"通话中";
            break;
        case WDGVideoConversationStateFinishCalling:
            return @"通话结束状态";
            break;
        default:
            return @"不可能状态 检查代码";
            break;
    }
}

NSString *WDGGetVideoFinshReason(WDGVideoFinishReason finishReason)
{
    switch (finishReason) {
        case WDGVideoFinishReasonNormal:
            return @"video当前状态不在通话结束状态";
            break;
        case WDGVideoFinishReasonCancel:
            return @"用户取消通话";
            break;
        case WDGVideoFinishReasonCancelByOppositeSide:
            return @"对方取消通话";
            break;
        case WDGVideoFinishReasonBusy:
            return @"对方正在通话中";
            break;
        case WDGVideoFinishReasonReject:
            return @"用户拒绝了通话";
            break;
        case WDGVideoFinishReasonRejectedByOppositeSide:
            return @"对方拒绝接听通话";
            break;
        case WDGVideoFinishReasonHungupByMySelf:
            return @"用户挂断了通话";
            break;
        case WDGVideoFinishReasonHungupByOppositeSide:
            return @"对方挂断了通话";
            break;
        case WDGVideoFinishReasonOutOfTimeForAnswer:
            return @"用户未在超时时间内做出应答";//接听或拒绝
            break;
        case WDGVideoFinishReasonNoAnswerByOppositeSide:
            return @"对方在超时时间内未做出应答";//接听或拒绝
            break;
        case WDGVideoFinishReasonOutOfTimeForReConnection:
            return @"网络质量差 未在规定时间内重连成功";
            break;
        case WDGVideoFinishReasonInBlack:
            return @"黑名单 不允许通话";
            break;
        case WDGVideoFinishReasonError:
            return @"sdk error";
            break;
        default:
            return @"不可能状态 检查代码";
            break;
    }
}

@interface WDGVideoConversationStatusShower : NSObject
-(void)updateConversationStatus:(WDGVideoConversationState)state fisishReason:(WDGVideoFinishReason)reason;
@end

@implementation WDGVideoConversationStatusShower
{
    UIView *_contentView;
    UILabel *_statusLabel;
    UILabel *_finishLabel;
}
+(instancetype)shower
{
    static WDGVideoConversationStatusShower *_shower =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shower = [[self alloc] init];
    });
    return _shower;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMyView];
    }
    return self;
}

-(void)initMyView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 70)];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _contentView.frame.size.width, 30)];
    _statusLabel =statusLabel;
    statusLabel.textColor = [UIColor redColor];
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, _contentView.frame.size.width, 30)];
    _finishLabel =finishLabel;
    finishLabel.textColor = [UIColor redColor];
    
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    [win addSubview:_contentView];
    [_contentView addSubview:_statusLabel];
    [_contentView addSubview:_finishLabel];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [_contentView addGestureRecognizer:panGesture];
}


- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    CGPoint translation = [panGestureRecognizer translationInView:win];
    CGFloat centerY =_contentView.center.y + translation.y;
    CGFloat minCenterY = _contentView.frame.size.height*.5;
    CGFloat maxCenterY = win.frame.size.height-minCenterY;
    if(centerY<minCenterY) centerY = minCenterY;
    if(centerY>maxCenterY) centerY = maxCenterY;
    _contentView.center = CGPointMake(_contentView.center.x, centerY);
    [panGestureRecognizer setTranslation:CGPointZero inView:win];
}

-(void)updateConversationStatus:(WDGVideoConversationState)state fisishReason:(WDGVideoFinishReason)reason
{
    NSString *stateT = [NSString stringWithFormat:@"   VideoStatus: %@",WDGGetVideoStatus(state)];
    _statusLabel.text =stateT;
    _finishLabel.text = [NSString stringWithFormat:@"   FinishReason: %@",WDGGetVideoFinshReason(reason)];
}

@end


@interface WDGVideoCallViewController ()<UIAlertViewDelegate,WDGVideoConversationStatusDelegate,WDGVideoConversationDelegate,WDGConversationStatsDelegate>
@property (nonatomic,strong) WDGVideoView *localView;
@property (nonatomic,strong) WDGVideoView *remoteView;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) WDGVideoConversation *conversation;
@property (nonatomic,strong) UIAlertView *receiveCallAlert;
@end

@implementation WDGVideoCallViewController
{

}


+(instancetype)controllerForConfig:(WDGVideoControllerConfig *)config
{
    WDGVideoCallViewController *callController = [[self alloc] init];
    callController.conversation =config.videoConversation;
    callController.conversation.statusDelegate =callController;
    callController.conversation.statsDelegate =callController;
    callController.conversation.conversationDelegate =callController;
    if(config.videoControllerType == WDGVideoControllerTypeReceiver){
        UIView *coverView = [[UIView alloc] initWithFrame:callController.view.bounds];
        callController.coverView =coverView;
        [callController.view addSubview:coverView];
        callController.coverView =coverView;
        callController.receiveCallAlert = [[UIAlertView alloc] initWithTitle:@"用户来电" message:[NSString stringWithFormat:@"id:%@",config.videoConversation.config.oppositeUid] delegate:callController cancelButtonTitle:@"拒绝" otherButtonTitles:@"接听", nil];
        [callController.receiveCallAlert show];
    }else{
        
        [callController display];
    }
    return callController;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.conversation reject];
    }else if(buttonIndex == 1){
        [self.conversation accept];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
        [self display];
    }
}

-(void)display
{
    [[WDGVideoConversationStatusShower shower] updateConversationStatus:_conversation.config.videoConversationState fisishReason:_conversation.config.videoFinishReason];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    CGFloat videoViewWidth = (self.view.frame.size.width - 5*3)*.5;
    CGFloat videoViewHeight = videoViewWidth/9*16;
    WDGVideoView *localView = [[WDGVideoView alloc] initWithFrame:CGRectMake(5, 100, videoViewWidth, videoViewHeight)];
    [self.view addSubview:localView];
    _localView =localView;
    [self.conversation.localStream attach:_localView];
    
    WDGVideoView *remoteView = [[WDGVideoView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(localView.frame)+5, CGRectGetMinY(localView.frame), CGRectGetWidth(localView.frame), CGRectGetHeight(localView.frame))];
    [self.view addSubview:remoteView];
    _remoteView =remoteView;
    
    UIButton *speakerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [speakerButton setTitle:@"关闭扬声器" forState:UIControlStateNormal];
    [speakerButton setTitle:@"打开扬声器" forState:UIControlStateSelected];
    [speakerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [speakerButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [speakerButton addTarget:self action:@selector(speakerOpen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speakerButton];
    speakerButton.frame = CGRectMake(0, 0, 300, 30);
    speakerButton.center = CGPointMake(self.view.frame.size.width*.5, CGRectGetMaxY(localView.frame)+50);
    
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitroomImmediately) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    exitButton.frame = CGRectMake(0, 0, 300, 30);
    exitButton.center = CGPointMake(self.view.frame.size.width*.5, CGRectGetMaxY(speakerButton.frame)+20);
}

-(void)speakerOpen:(UIButton *)speakerBtn
{
    speakerBtn.selected =!speakerBtn.selected;
    self.conversation.shouldLoudspeaker = !speakerBtn.selected;
}

-(void)exitroomImmediately
{
    [self.conversation close];
}

-(void)exitRoom
{
    if(_receiveCallAlert.visible){
        [_receiveCallAlert dismissWithClickedButtonIndex:2 animated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoStatusDidChanged:(WDGVideoConversation *)videoConversation
{
    [self display];
}

-(void)videoConversationDidClosed:(WDGVideoConversation *)videoConversation
{
    [self exitRoom];
}

-(void)remoteStreamDidAdded:(WDGVideoConversation *)videoConversation
{
    [self.conversation.remoteStream attach:_remoteView];
}

-(void)dealloc
{
    NSLog(@"controller dealloc");
    NSLog(@"当前通话的通话时长为%fs",self.conversation.config.currentTime);
}
@end
