//
//  WDGVideoReceiveViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoReceiveViewController.h"
#import "WDGReciveCallViewController.h"
#import <WilddogVideo/WilddogVideo.h>
#import "WilddogSDKManager.h"
@interface WDGVideoReceiveViewController ()
@property (nonatomic, strong) WDGReciveCallViewController *receiveController;
@end

@implementation WDGVideoReceiveViewController
+(instancetype)receiveCallWithConversation:(WDGConversation *)conversation{
    WDGVideoReceiveViewController *rc = [WDGVideoReceiveViewController controllerWithType:VideoTypeReciver];
    rc.conversation = conversation;
    rc.oppositeID = conversation.remoteUid;
    return rc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.receiveController];
    [self.view addSubview:self.receiveController.view];
    [WDGSoundPlayer playSound:SoundTypeCallee];
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
    [self.conversation reject];
}

-(void)connect
{
    [self.conversation acceptWithLocalStream:self.localStream];
    [self dismissReceiveController];
}

- (void)dismissReceiveController
{
    [_receiveController.view removeFromSuperview];
    [_receiveController removeFromParentViewController];
    _receiveController = nil;
}
@end
