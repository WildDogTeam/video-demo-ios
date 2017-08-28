//
//  WDGVideoCallViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoCallViewController.h"
#import "WilddogSDKManager.h"
#import "UIView+MBProgressHud.h"
#import "WDGVideoControlView.h"
#import <WilddogVideo/WDGConversation.h>
#import "WDGSignalPush.h"
@interface WDGVideoCallViewController ()
@property (nonatomic, strong) UILabel *callingLabel;
@property (nonatomic, strong) UILabel *oppoUidLabel;
@end

@implementation WDGVideoCallViewController

+(instancetype)makeCallToUserItem:(WDGVideoItem *)userItem
{
    WDGVideoCallViewController *cc = [self controllerWithType:VideoTypeCaller];
    cc.oppositeItem =userItem;
    return cc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self createNoticeView];
    [self rendarViewWithLocalStream:self.localStream remoteStream:nil];
    self.conversation =[[WilddogSDKManager sharedManager].wilddogVideo callWithUid:self.oppositeItem.uid localStream:self.localStream data:nil];
    [WDGSignalPush pushVideoCallWithUid:self.oppositeItem.uid];
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

-(void)conversation:(WDGConversation *)conversation didReceiveResponse:(WDGCallStatus)callStatus
{
    [WDGSoundPlayer stop];
    if(callStatus == WDGCallStatusAccepted){
//        [self dismissNoticeView];
    }else{
        [super conversation:conversation didReceiveResponse:callStatus];
    }
}

-(void)createNoticeView
{
    UILabel *callingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 32)];
    callingLabel.text = @"正在呼叫...";
    callingLabel.textColor = [UIColor whiteColor];
    callingLabel.textAlignment = NSTextAlignmentCenter;
    callingLabel.font = [UIFont fontWithName:@"pingfang SC" size:30];
    [self.view addSubview:callingLabel];
    self.callingLabel =callingLabel;
    
    UILabel *oppoUidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.callingLabel.frame)+10, self.view.frame.size.width, 22)];
    oppoUidLabel.text = self.oppositeItem.description;
    oppoUidLabel.textAlignment = NSTextAlignmentCenter;
    oppoUidLabel.textColor = [UIColor whiteColor];
    oppoUidLabel.font = [UIFont fontWithName:@"pingfang SC" size:20];
    [self.view addSubview:oppoUidLabel];
    self.oppoUidLabel =oppoUidLabel;
}

-(void)dismissNoticeView
{
    [self.callingLabel removeFromSuperview];
    self.callingLabel = nil;
    [self.oppoUidLabel removeFromSuperview];
    self.oppoUidLabel = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
