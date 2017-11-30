//
//  WDGRoomViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/11/20.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGRoomViewController.h"
#import <WilddogVideoRoom/WilddogVideoRoom.h>
#import "WDGVideoControlView.h"
#import <AVFoundation/AVFoundation.h>
#import "WDGRoomCollectionViewCell.h"
#import "UIView+MBProgressHud.h"
@interface WDGRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WDGRoomDelegate,WDGVideoControl,UIActionSheetDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,copy) NSString *roomId;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <WDGRoomCollectionViewCellLayout *>*streams;
@property (nonatomic, strong) WDGRoom *room;
@property (nonatomic, strong) WDGLocalStream *localStream;

@property (nonatomic, strong) WDGVideoControlView *controlView;

@property (nonatomic,assign) BOOL shouldLoudSpeaker;
@property (nonatomic,assign) BOOL cameraIsFront;
@end

@implementation WDGRoomViewController

+(instancetype)roomControllerWithRoomId:(NSString *)roomId
{
    WDGRoomViewController *roomVC = [[self alloc] init];
    roomVC.roomId =roomId;
    return roomVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cameraIsFront =YES;
    [UIApplication sharedApplication].statusBarHidden=YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =self;
    self.navigationController.navigationBar.hidden =YES;
    [UIApplication sharedApplication].idleTimerDisabled =YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:24/255. green:26/255. blue:31/255. alpha:1.];
    self.streams =[NSMutableArray array];
    CGFloat collectionViewHeight =self.view.frame.size.height -ControlItemsViewHeight -10;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(self.view.frame.size.width/2, collectionViewHeight/3);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, collectionViewHeight) collectionViewLayout:layout];
    collectionView.dataSource =self;
    collectionView.delegate =self;
    [self.view addSubview:collectionView];
    self.collectionView =collectionView;
    collectionView.backgroundColor = [UIColor colorWithRed:0x1f/255. green:0x22/255. blue:0x28/255. alpha:1.];
    [collectionView registerClass:[WDGRoomCollectionViewCell class] forCellWithReuseIdentifier:[WDGRoomCollectionViewCell identifier]];
    collectionView.collectionViewLayout = layout;
//    collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self setupLocalStream];
    _room = [[WDGRoom alloc] initWithRoomId:_roomId delegate:self];
    [_room connect];
    _controlView = [[WDGVideoControlView alloc] init];
    _controlView.controlDelegate =self;
    _controlView.mode =WDGVideoControlViewModeRoom;
    [self.view addSubview:_controlView];
    [self.view sendSubviewToBack:_controlView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    self.shouldLoudSpeaker = YES;
}

-(void)exitRoom
{
    [_room disconnect];
    [UIApplication sharedApplication].statusBarHidden=NO;
    self.navigationController.interactivePopGestureRecognizer.delegate=nil;
    self.navigationController.navigationBar.hidden =NO;
    [UIApplication sharedApplication].idleTimerDisabled =NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setShouldLoudSpeaker:(BOOL)shouldLoudSpeaker
{
    _shouldLoudSpeaker =shouldLoudSpeaker;
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:_shouldLoudSpeaker?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:nil];
}

- (void)didSessionRouteChange:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            // 耳机插入
            [self.controlView changeAudioSpeakerState:NO];
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            [self.controlView changeAudioSpeakerState:self.shouldLoudSpeaker];
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:self.shouldLoudSpeaker?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:nil];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:self.shouldLoudSpeaker?AVAudioSessionPortOverrideSpeaker:AVAudioSessionPortOverrideNone error:nil];
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - WDGRoomDelegate

- (void)wilddogRoomDidConnect:(WDGRoom *)wilddogRoom {
    NSLog(@"Room Connected!");
    // 发布本地流
    [self publishLocalStream];
}

- (void)wilddogRoomDidDisconnect:(WDGRoom *)wilddogRoom {
    NSLog(@"Room Disconnected!");
    //__weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //__strong __typeof__(self) strongSelf = weakSelf;
        NSLog(@"Disconnected!");
        [self dismissViewControllerAnimated:YES completion:NULL];
    });
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didStreamAdded:(WDGRoomStream *)roomStream {
    NSLog(@"RoomStream Added!");
    [self subscribeRoomStream:roomStream];
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didStreamRemoved:(WDGRoomStream *)roomStream {
    NSLog(@"RoomStream Removed!");
    [self unsubscribeRoomStream:roomStream];
    for (WDGRoomCollectionViewCellLayout *layout in self.streams) {
        if(layout.stream == roomStream){
            [self.streams removeObject:layout];
            break;
        }
    }
    [self.collectionView reloadData];
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didStreamReceived:(WDGRoomStream *)roomStream {
    NSLog(@"RoomStream Received!");
    WDGRoomCollectionViewCellLayout *layout = [WDGRoomCollectionViewCellLayout new];
    layout.stream =roomStream;
    [self.streams addObject:layout];
    [self.collectionView reloadData];
}

- (void)wilddogRoom:(WDGRoom *)wilddogRoom didFailWithError:(NSError *)error {
    NSLog(@"Room Failed: %@", error);
    
}

#pragma mark - Internal methods

- (void)setupLocalStream {
    // 创建本地流
    WDGLocalStreamOptions *localStreamOptions = [[WDGLocalStreamOptions alloc] init];
    localStreamOptions.shouldCaptureAudio = YES;
    localStreamOptions.dimension = WDGVideoDimensions720p;
    self.localStream = [WDGLocalStream localStreamWithOptions:localStreamOptions];
    WDGRoomCollectionViewCellLayout *layout = [WDGRoomCollectionViewCellLayout new];
    layout.stream =self.localStream;
    [self.streams addObject:layout];
    [self.collectionView reloadData];
}

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
    if(self.cameraIsFront&&indexPath.row==0){
        self.streams[indexPath.row].needMirror=YES;
    }else{
        self.streams[indexPath.row].needMirror=NO;
    }
    cell.layout=self.streams[indexPath.row];
    return cell;
    
}

-(void)videoControlView:(WDGVideoControlView *)controlView microphoneDidClick:(BOOL)isOpened;
{
    self.localStream.audioEnabled = isOpened;
}

-(void)videoControlViewDidHangup:(WDGVideoControlView *)controlView;
{
    [self exitRoom];
}

-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidTurned:(BOOL)isFront;
{
    self.cameraIsFront = isFront;
    [self.localStream switchCamera];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}

-(void)videoControlView:(WDGVideoControlView *)controlView speakerDidOpen:(BOOL)micphoneOpened;
{
    self.shouldLoudSpeaker = !micphoneOpened;
}

-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidOpen:(BOOL)cameraOpen;
{
    self.localStream.videoEnabled = cameraOpen;
}

-(void)videoControlViewDidInviteOthers:(WDGVideoControlView *)controlView;
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"room dealloc");
}

@end
