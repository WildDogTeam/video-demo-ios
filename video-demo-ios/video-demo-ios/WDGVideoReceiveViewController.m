//
//  WDGVideoReceiveViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoReceiveViewController.h"
#import <WilddogVideo/WDGVideoIncomingInvite.h>
#import "WDGReciveCallViewController.h"
#import <WilddogVideo/WilddogVideo.h>
@interface WDGVideoReceiveViewController ()
@property (nonatomic, strong) WDGVideoIncomingInvite *invite;
@property (nonatomic, strong) WDGReciveCallViewController *receiveController;
@end

@implementation WDGVideoReceiveViewController
+(instancetype)receiveCallWithIncomingInvite:(WDGVideoIncomingInvite *)invite
{
    WDGVideoReceiveViewController *rc = [WDGVideoReceiveViewController controllerWithType:VideoTypeReciver];
    rc.invite = invite;
    return rc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.receiveController];
    [self.view addSubview:self.receiveController.view];
}

-(WDGReciveCallViewController *)receiveController
{
    if(!_receiveController){
        __weak typeof(self) WS = self;
        _receiveController =[WDGReciveCallViewController controllerWithCallerID:self.invite.fromParticipantID userAccept:^(BOOL accept) {
            __strong typeof(WS)self =WS;
            if(!accept){
                [self reject];
                [self closeRoom];
            }else{
                [self connect];
            }
        }];
    }
    return _receiveController;
}

-(void)reject
{
    [_invite reject];
}

-(void)connect
{
    __weak typeof(self) WS = self;
    [_invite acceptWithLocalStream:self.localStream completion:^(WDGVideoConversation * _Nullable conversation, NSError * _Nullable error) {
        __strong typeof(WS) self = WS;
//        self.localStream = conversation.localParticipant.stream;
        self.conversation =conversation;
        [self dismissReceiveController];
    }];
}

- (void)dismissReceiveController
{
    [_receiveController.view removeFromSuperview];
    [_receiveController removeFromParentViewController];
    _receiveController = nil;
}

-(void)callCancelled
{
    [self closeRoom];
}

-(void)closeRoom
{
    [super closeRoom];
    _invite = nil;
}

@end
