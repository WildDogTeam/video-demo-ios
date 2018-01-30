//
//  WDGComplexRoomViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/11/23.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGComplexRoomViewController.h"
#import "BoardToolBar.h"
#import <AVFoundation/AVFoundation.h>
#import <WilddogVideoRoom/WilddogVideoRoom.h>
#import <WilddogVideoBase/WilddogVideoBase.h>
#import "WDGAccount.h"
#import "WDGChatView.h"
#import "WDGRoomCollectionViewCell.h"
#import "UIView+MBProgressHud.h"
#import "WDGUserDefine.h"
#import "WDGiPhoneXAdapter.h"
#import "WDGVideoConfig.h"
#import "WDGTextView.h"
#import "WilddogSDKManager.h"
#import <WilddogSync/WilddogSync.h>
#import "WDGTimer.h"
#import "WDGRoomManager.h"
@import WilddogBoard;

#define animationTime .5


#define screenProportion ((self.view.frame.size.width-WDG_ViewSafeAreInsetsLeft-WDG_ViewSafeAreInsetsRight)/667)
#define collectionViewMaxWidth (166*screenProportion)


typedef NS_ENUM(NSUInteger,RoomMemberStyle){
    RoomMemberStyleSimple,
    RoomMemberStyleComplex
};

@interface WDGComplexRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIGestureRecognizerDelegate,WDGRoomDelegate>
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,strong) UIColor *navigationBarStorageColor;
@property (nonatomic, strong) WDGRoom *room;
@property (nonatomic, strong) WDGRoomManager *roomManager;
@property (nonatomic, strong) WDGLocalStream *localStream;
@property (nonatomic, strong) NSMutableArray<WDGRoomCollectionViewCellLayout *> *streams;
@property (nonatomic, strong) WDGBoard *boardView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) WDGChatView *chatView;
@property (nonatomic,assign) RoomMemberStyle style;
@property (nonatomic,strong) UILabel *membersCountLabel;
@property (nonatomic,strong) UIButton *showerButton;
@property (nonatomic,strong) WDGTextView *textView;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic,strong) WDGTimer *timer;
@end

@implementation WDGComplexRoomViewController

+(instancetype)roomControllerWithRoomId:(NSString *)roomId
{
    WDGComplexRoomViewController *roomVC = [[self alloc] init];
    roomVC.roomId =roomId;
    return roomVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self confirmStartTime];
    // Do any setup after loading the view.
    [self initController];
    [self createNavigationItems];

    [self createBoard];
    [self createCollectionView];
    [self createChatView];
    [self addShowerButton];
    [self createMessageInputView];
    [self setupLocalStream];
    [self audioSpeaker];
    _room = [[WDGRoom alloc] initWithRoomId:_roomId delegate:self];
    [_room connect];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)confirmStartTime
{
    __weak typeof(self) WS =self;
    _roomManager = [[WDGRoomManager alloc] initWithRoomId:_roomId complete:^(NSTimeInterval time) {
        __strong typeof(WS) self =WS;
        self.startTime = time;
        [self createTimer];
    }];
}

-(void)createTimer
{
    NSUInteger enterTime = (NSUInteger)([[NSDate date] timeIntervalSince1970]-self.startTime/1000);
    __weak typeof(self) WS =self;
    self.timer = [WDGTimer timerWithstart:enterTime interval:1 block:^(NSTimeInterval timeInterval) {
        __strong typeof(WS) self =WS;
        NSInteger time =(NSInteger)timeInterval;
        UIButton *btn = self.navigationItem.titleView;
        btn.titleLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",time/60/60,time/60%60,time%60];
    }];
}

-(void)initController
{
    [UIApplication sharedApplication].statusBarHidden=NO;
    self.navigationBarStorageColor = self.navigationController.navigationBar.barTintColor;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.interactivePopGestureRecognizer.delegate =self;
    _streams = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)createNavigationItems
{
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [exitButton setTitle:@"退出房间" forState:UIControlStateNormal];
    [exitButton setImage:[UIImage imageNamed:@"向左箭头1"] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    exitButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    exitButton.frame = CGRectMake(0, 0, 120, 44);
    exitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    exitButton.contentEdgeInsets =UIEdgeInsetsMake(0, -5, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:exitButton];
    
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [inviteButton setTitle:@"邀请他人" forState:UIControlStateNormal];
    [inviteButton setImage:[UIImage imageNamed:@"小邀请他人"] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(inviteOthers) forControlEvents:UIControlEventTouchUpInside];
    inviteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
    inviteButton.frame = CGRectMake(0, 0, 120, 44);
    inviteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    inviteButton.contentEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 5);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
    
    UIButton *titleView = [UIButton buttonWithType:UIButtonTypeCustom];
    titleView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [titleView setTitle:@"--:--:--" forState:UIControlStateNormal];
    [titleView setImage:[UIImage imageNamed:@"上课中"] forState:UIControlStateNormal];
    titleView.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    titleView.frame = CGRectMake(0, 0, 120, 44);
    titleView.userInteractionEnabled =NO;
    self.navigationItem.titleView = titleView;
}

-(void)goBack
{
    _room.delegate=nil;
    [_room disconnect];
    [self.timer invalidate];
    [_roomManager closeOperation];
    self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    self.navigationController.navigationBar.barTintColor =self.navigationBarStorageColor;
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"maskportrait" object:nil];
}

-(void)inviteOthers
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"房间号:%@",self.roomId] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"复制房间号" otherButtonTitles:@"复制房间地址", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *text = buttonIndex==0?_roomId:buttonIndex==1?@"https://www.wilddog.com/product/webrtc-demo/join":nil;
    if(text.length){
        [UIPasteboard generalPasteboard].string = text;
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"已复制" hideAfter:1 animate:YES];
    }
}

-(void)createBoard
{
    WDGBoardOptions *option = [WDGBoardOptions defaultOptions];
    //画布尺寸，保持与其它端统一
    option.canvasSize = CGSizeMake(1366, 768);
    
    WDGBoard *boardView = [WDGBoard creatBoardWithAppID:WDGSyncId
                                                   Path:[NSString stringWithFormat:@"room/%@/board",_roomId]
                                                 userID:[WDGAccountManager currentAccount].userID
                                               opthions:option];
    
    
    boardView.frame = CGRectMake(WDG_ViewSafeAreInsetsLeft, 0,
                                 self.view.frame.size.width -WDG_ViewSafeAreInsetsLeft -WDG_ViewSafeAreInsetsRight,
                                 self.view.frame.size.height -self.navigationController.navigationBar.frame.size.height-WDG_ViewSafeAreInsetsTop-WDG_ViewSafeAreInsetsBottom-WDG_StatusbarHeight);
    
    boardView.layer.masksToBounds = YES;
    boardView.backgroundColor = [UIColor blackColor];

    [self.view addSubview:boardView];
    _boardView = boardView;
    NSLog(@"%@",NSStringFromUIEdgeInsets(WDG_ViewSafeAreInsets));
    CGRect rect =CGRectMake((self.view.frame.size.width - 350)*.5,self.view.frame.size.height -55-self.navigationController.navigationBar.frame.size.height -WDG_ViewSafeAreInsetsTop-WDG_ViewSafeAreInsetsBottom -WDG_StatusbarHeight,350,55);
    BoardToolBar *toolbar = [BoardToolBar new];
    [toolbar setupWithBoard:boardView
                  direction:BoardToolBarDirectionHorizontal
                      theme:BoardToolThemeDark
                      frame:rect
     ];

    [self.view addSubview:toolbar];
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(60*screenProportion, 60*screenProportion);
    layout.sectionInset = UIEdgeInsetsMake(0, 14, 10, 14);
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(WDG_ViewSafeAreInsetsLeft, 20, 74*screenProportion, 275) collectionViewLayout:layout];
    collectionView.dataSource =self;
    collectionView.delegate =self;
    collectionView.backgroundColor = [UIColor colorWithRed:46/255. green:46/255. blue:46/255. alpha:1.];
    [collectionView registerClass:[WDGRoomCollectionViewCell class] forCellWithReuseIdentifier:[WDGRoomCollectionViewCell identifier]];
    [self.view addSubview:collectionView];
    collectionView.layer.cornerRadius =5;
    collectionView.clipsToBounds=YES;
    UILabel *membersCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(collectionView.frame.origin.x, collectionView.frame.origin.y, collectionView.frame.size.width, 24)];
    membersCountLabel.text = [NSString stringWithFormat:@"房间成员(%lu)",(unsigned long)_streams.count];
    membersCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    membersCountLabel.textAlignment = NSTextAlignmentCenter;
    membersCountLabel.textColor = [UIColor whiteColor];
    _membersCountLabel =membersCountLabel;
    [self.view addSubview:membersCountLabel];
    collectionView.contentInset = UIEdgeInsetsMake(membersCountLabel.frame.size.height, 0, 0, 0);
    _collectionView =collectionView;
    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [collectionView addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [collectionView addGestureRecognizer:recognizer];
}

-(void)createChatView
{
    WDGChatView *chatView = [WDGChatView viewWithNickname:[WDGAccountManager currentAccount].nickName roomId:_roomId frame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width-collectionViewMaxWidth-WDG_ViewSafeAreInsetsLeft-WDG_ViewSafeAreInsetsRight, self.view.frame.size.height-WDG_StatusbarHeight-self.navigationController.navigationBar.frame.size.height-WDG_ViewSafeAreInsetsBottom-WDG_ViewSafeAreInsetsTop-49)];
    self.chatView =chatView;
    chatView.hidden =YES;
    chatView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chatView];
    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    recognizer.delegate = self;
    [chatView addGestureRecognizer:recognizer];
}

-(void)createMessageInputView
{
    _textView = [[WDGTextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.chatView.frame), CGRectGetMaxY(self.chatView.frame), CGRectGetWidth(self.chatView.frame), 49)];
    _textView.hidden =YES;
    [_textView setPlaceholderText:@"请输入..."];
    __weak typeof(self) WS =self;
    _textView.textViewBlock = ^(NSString *message){
        [WS.chatView sendMessage:message];
    };
    _textView.superfluousHeightWhenKeyboardHide=^(CGFloat superfluousHeight){
        WS.chatView.insetBottom =superfluousHeight;
    };
    [self.view addSubview:_textView];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"左滑手势");
        [self hideMembersChat];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"右滑手势");
        if(recognizer.view == self.collectionView){
            [self showMembersChat];
        }else{
            [self hideMembersChat];
        }
    }
}

-(void)hideMembersChat
{
    if(self.style==RoomMemberStyleComplex){
        self.style = RoomMemberStyleSimple;
        [UIView animateWithDuration:animationTime animations:^{
            self.collectionView.frame = CGRectMake(WDG_ViewSafeAreInsetsLeft, WDG_ViewSafeAreInsetsTop+20, 74*screenProportion, 275);
            ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(60*screenProportion, 60*screenProportion);
            self.chatView.center = CGPointMake(self.chatView.center.x+self.chatView.frame.size.width+WDG_ViewSafeAreInsetsRight, self.chatView.center.y);
            [self.textView updateFrame:CGRectMake(CGRectGetMinX(self.chatView.frame), CGRectGetMaxY(self.chatView.frame), CGRectGetWidth(self.chatView.frame), 49)];
            self.membersCountLabel.center =CGPointMake(self.membersCountLabel.center.x, self.membersCountLabel.center.y+20);
            self.showerButton.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame), 140, 8*1.5, 48*1.5);
        } completion:^(BOOL finished) {
            self.chatView.hidden =YES;
            self.textView.hidden =YES;
        }];
    }
}

-(void)showMembersChat
{
    if(self.style==RoomMemberStyleSimple){
        self.style = RoomMemberStyleComplex;
        self.chatView.hidden=NO;
        self.textView.hidden =NO;
        [UIView animateWithDuration:animationTime animations:^{
            self.collectionView.frame = CGRectMake(WDG_ViewSafeAreInsetsLeft, 0, collectionViewMaxWidth, self.view.frame.size.height-WDG_ViewSafeAreInsetsBottom);
            ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(150*screenProportion, 110*screenProportion);
            self.membersCountLabel.center =CGPointMake(self.membersCountLabel.center.x, self.membersCountLabel.center.y-20);
            self.chatView.center = CGPointMake(self.chatView.center.x-self.chatView.frame.size.width-WDG_ViewSafeAreInsetsRight, self.chatView.center.y);
            [self.textView updateFrame:CGRectMake(CGRectGetMinX(self.chatView.frame), CGRectGetMaxY(self.chatView.frame), CGRectGetWidth(self.chatView.frame), 49)];
            self.showerButton.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame), 140, 8*1.5, 48*1.5);
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)addShowerButton
{
    UIButton *showerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showerButton setImage:[UIImage imageNamed:@"division"] forState:UIControlStateNormal];
    [showerButton addTarget:self action:@selector(showerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    showerButton.backgroundColor =[UIColor colorWithRed:46/255. green:46/255. blue:46/255. alpha:1.];
    showerButton.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame), 140, 8*1.5, 48*1.5);
    [self.view addSubview:showerButton];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:showerButton.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(8*1.5*.5,8*1.5*.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = showerButton.bounds;
    maskLayer.path = maskPath.CGPath;
    showerButton.layer.mask = maskLayer;
    _showerButton =showerButton;
}

-(void)showerButtonClick:(UIButton *)showerButton
{
    if(self.style==RoomMemberStyleComplex){
        [self hideMembersChat];
    }else{
        [self showMembersChat];
    }
}

- (void)setupLocalStream {
    // 创建本地流
    WDGLocalStreamOptions *localStreamOptions = [[WDGLocalStreamOptions alloc] init];
    localStreamOptions.shouldCaptureAudio = YES;
    localStreamOptions.dimension = [WDGVideoConfig videoConstraintsNum];
    self.localStream = [WDGLocalStream localStreamWithOptions:localStreamOptions];

    [self addStream:self.localStream];
    [self.collectionView reloadData];
}

-(void)addStream:(WDGStream *)stream
{
    WDGRoomCollectionViewCellLayout *layout = [WDGRoomCollectionViewCellLayout new];
    layout.stream =stream;
    layout.cornerRadius =4;
    [self.streams addObject:layout];
    _membersCountLabel.text = [NSString stringWithFormat:@"房间成员(%lu)",(unsigned long)_streams.count];
}

-(void)removeStream:(WDGStream *)stream
{
    for (WDGRoomCollectionViewCellLayout *layout in self.streams) {
        if(layout.stream == stream){
            [self.streams removeObject:layout];
            break;
        }
    }
    _membersCountLabel.text = [NSString stringWithFormat:@"房间成员(%lu)",(unsigned long)_streams.count];
}

-(void)audioSpeaker
{
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
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
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - Client Operation

- (void)publishLocalStream {
    if (self.localStream) {
        [self.room publishLocalStream:self.localStream withCompletionBlock:^(NSError * _Nullable error) {
            NSLog(@"Publish Completion Block");
        }];
    }
}

- (void)unpublishLocalStream {
    if (self.localStream) {
        [self.room unpublishLocalStream:self.localStream withCompletionBlock:^(NSError * _Nullable error) {
            NSLog(@"Unpublish Completion Block");
        }];
    }
}

- (void)subscribeRoomStream:(WDGRoomStream *)roomStream {
    if (roomStream) {
        [self.room subscribeRoomStream:roomStream withCompletionBlock:^(NSError * _Nullable error) {
            NSLog(@"Subscribe Completion Block");
        }];
    }
}

- (void)unsubscribeRoomStream:(WDGRoomStream *)roomStream {
    if (roomStream) {
        [self.room unsubscribeRoomStream:roomStream withCompletionBlock:^(NSError * _Nullable error) {
            NSLog(@"Unsubscribe Completion Block");
        }];
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.streams.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WDGRoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WDGRoomCollectionViewCell identifier] forIndexPath:indexPath];
    cell.layout=self.streams[indexPath.row];
    return cell;
    
}

#pragma mark - WDGRoomDelegate

- (void)wilddogRoomDidConnect:(WDGRoom *)wilddogRoom {
    NSLog(@"Room Connected!");
    // 发布本地流
    [self publishLocalStream];
}

- (void)wilddogRoomDidDisconnect:(WDGRoom *)wilddogRoom {
    NSLog(@"Room Disconnected!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self goBack];
    });
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didStreamAdded:(WDGRoomStream *)roomStream {
    NSLog(@"RoomStream Added!");
    [self subscribeRoomStream:roomStream];
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didStreamRemoved:(WDGRoomStream *)roomStream {
    NSLog(@"RoomStream Removed!");
    [self unsubscribeRoomStream:roomStream];
    [self removeStream:roomStream];
    [self.collectionView reloadData];
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didStreamReceived:(WDGRoomStream *)roomStream {
    NSLog(@"RoomStream Received!");
    [self addStream:roomStream];
    [self.collectionView reloadData];
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didFailWithError:(NSError *)error {
    NSLog(@"Room Failed: %@", error);
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"会议错误: %@", [error localizedDescription]];
       // [self showAlertWithTitle:@"提示" message:errorMessage];
    }
}

#pragma mark - controller init
-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return !(gestureRecognizer == self.navigationController.interactivePopGestureRecognizer);
}

-(void)dealloc
{
    NSLog(@"room controller dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)applicationDidBecomeActive
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"masklandscaperight" object:nil];
}


@end
