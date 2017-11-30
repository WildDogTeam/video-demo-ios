//
//  WDGVideoReceiveViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoReceiveViewController.h"
#import "WDGReciveCallViewController.h"
#import <WilddogVideoCall/WilddogVideoCall.h>
#import "WilddogSDKManager.h"
@interface WDGVideoReceiveViewController ()
@property (nonatomic, strong) WDGReciveCallViewController *receiveController;
@property (nonatomic, strong) NSTimer *outTimeTimer;
@end

@implementation WDGVideoReceiveViewController
+(instancetype)receiveCallWithConversation:(WDGConversation *)conversation userItem:(WDGVideoUserItem *)userItem
{
    
    WDGVideoReceiveViewController *rc = [WDGVideoReceiveViewController controllerWithType:VideoTypeReciver];
    rc.conversation = conversation;
    rc.oppositeItem = userItem;
    return rc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.receiveController];
    [self.view addSubview:self.receiveController.view];
//    [self addOutTimeTimer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [WDGSoundPlayer playSound:SoundTypeCaller];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [WDGSoundPlayer stop];
}

-(WDGReciveCallViewController *)receiveController
{
    if(!_receiveController){
        __weak typeof(self) WS = self;
        _receiveController =[WDGReciveCallViewController controllerWithCallerID:self.conversation.remoteUid userAccept:^(BOOL accept) {
            __strong typeof(WS)self =WS;
            [WDGSoundPlayer stop];
            if(!accept){
                [self reject];
                [self closeConversation];
            }else{
                [self connect];
            }
        }];
    }
    return _receiveController;
}

-(void)reject
{
//    [self timerInvalidate];
    [self.conversation reject];
}

-(void)connect
{
//    [self timerInvalidate];
    [self.conversation acceptWithLocalStream:self.localStream];
    [self dismissReceiveController];
}

- (void)dismissReceiveController
{
    [_receiveController.view removeFromSuperview];
    [_receiveController removeFromParentViewController];
    _receiveController = nil;
}

//-(void)addOutTimeTimer
//{
//    self.outTimeTimer = [NSTimer scheduledTimerWithTimeInterval:35 target:self selector:@selector(closeRoom) userInfo:nil repeats:NO];
//}
//
//-(void)closeRoom
//{
//    [self reject];
//    [super closeRoom];
//}
//
//-(void)timerInvalidate
//{
//    [self.outTimeTimer invalidate];
//    self.outTimeTimer = nil;
//}
@end
