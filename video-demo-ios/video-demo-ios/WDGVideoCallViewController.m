//
//  WDGVideoCallViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoCallViewController.h"
#import <WilddogVideo/WDGVideoOutgoingInvite.h>
#import <WilddogVideo/WDGVideoConnectOptions.h>
#import "WilddogSDKManager.h"
#import "UIView+MBProgressHud.h"
#import "WDGVideoControlView.h"
@interface WDGVideoCallViewController ()
@property (nonatomic,copy) NSString *oppoUid;
@property (nonatomic, strong) WDGVideoOutgoingInvite *outgoingInvite;
@property (nonatomic, strong) UILabel *callingLabel;
@property (nonatomic, strong) UILabel *oppoUidLabel;
@end

@implementation WDGVideoCallViewController

+(instancetype)makeCallToUserId:(nonnull NSString *)userId
{
    WDGVideoCallViewController *cc = [self controllerWithType:VideoTypeReciver];
    cc.oppoUid = userId;
    return cc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNoticeView];
    [self rendarViewWithLocalStream:self.localStream remoteStream:nil];
    WDGVideoConnectOptions *connectOptions = [[WDGVideoConnectOptions alloc] initWithLocalStream:self.localStream];
    __weak typeof(self) WS =self;
    self.outgoingInvite = [[WilddogSDKManager sharedManager].wilddogVideoClient inviteToConversationWithID:_oppoUid options:connectOptions completion:^(WDGVideoConversation * _Nullable conversation, NSError * _Nullable error) {
        __strong typeof(WS) self =WS;
        if (error) {
            if(error.code == 40203){
                [self.view showHUDWithMessage:@"对方拒绝了你的邀请" hideAfter:1 animate:YES];
            }else if(error.code == 40204){
                [self.view showHUDWithMessage:@"你所拨打的用户正在通话中，请稍后再试" hideAfter:1 animate:YES];
            }else{
                [self.view showHUDWithMessage:[NSString stringWithFormat:@"ERR:code=%ld",error.code] hideAfter:1 animate:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeRoom];
            });
            return ;
        }
        [self dismissNoticeView];
        self.conversation =conversation;
    }];
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
    oppoUidLabel.text = self.oppoUid;
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

-(void)closeRoom
{
    [super closeRoom];
    [self.outgoingInvite cancel];
}

-(void)videoControlViewDidHangup:(WDGVideoControlView *)controlView
{
    [super videoControlViewDidHangup:controlView];
    [_outgoingInvite cancel];
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
