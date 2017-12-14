//
//  WDGLoginViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/6/30.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGLoginViewController.h"
#import "WDGLoginManager.h"
#import <WXApi.h>
#import "WDGUserDefine.h"
#import "WDGNotifications.h"
#import "UIView+MBProgressHud.h"
#import "WDGImageTool.h"
#import "WDGUserNoticeViewController.h"
@interface WDGLoginViewController ()
@property (nonatomic,assign) BOOL loginByWechat;
@property (nonatomic,assign) BOOL loginByWechatCancelled;
@end

@implementation WDGLoginViewController
{
    UILabel *_noticeLabel;
    UIButton *_noticeBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    CGFloat centerX = self.view.bounds.size.width*.5;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyphs"]];
    imageView.frame = CGRectMake(0, 0, 75, 75);
    imageView.center = CGPointMake(centerX, 200+CGRectGetHeight(imageView.frame)*.5);
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [self pingfangLabelWithText:@"野狗视频通话" size:24];
    titleLabel.textColor = [UIColor colorWithRed:0x33/255. green:0x33/255. blue:0x33/255. alpha:1];
    titleLabel.center = CGPointMake(centerX, CGRectGetMaxY(imageView.frame)+22+CGRectGetHeight(titleLabel.frame)*.5);
    [self.view addSubview:titleLabel];
    
    UILabel *detailLabel = [self pingfangLabelWithText:@"" size:15];
    detailLabel.center = CGPointMake(centerX, CGRectGetMaxY(titleLabel.frame)+10+CGRectGetHeight(detailLabel.frame)*.5);
    [self.view addSubview:detailLabel];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:([WXApi isWXAppInstalled]&&WDGAppUseWechatLogin)?@"微信登录":@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.textColor = [UIColor whiteColor];
    loginButton.frame = CGRectMake(0, 0, 241, 41);
    loginButton.center = CGPointMake(centerX, CGRectGetMaxY(detailLabel.frame)+99+CGRectGetHeight(loginButton.frame)*.5);
    UIColor *normalColor = [UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.];
    UIColor *highlightColor = [UIColor colorWithRed:0xf0/255. green:0x91/255. blue:0x6e/255. alpha:1.];
    [loginButton setBackgroundImage:[WDGImageTool imageFromColor:normalColor size:loginButton.frame.size] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[WDGImageTool imageFromColor:highlightColor size:loginButton.frame.size] forState:UIControlStateHighlighted];
    loginButton.layer.cornerRadius = CGRectGetHeight(loginButton.frame)*.5;
    loginButton.clipsToBounds =YES;
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
//    条款
    UILabel *noticeLabel = [self pingfangLabelWithText:@"登录代表你已同意" size:10];
    [self.view addSubview:noticeLabel];
    UIButton *noticeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [noticeBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [noticeBtn setTitleColor:[UIColor colorWithRed:221/255. green:58/255. blue:39/255. alpha:1.] forState:UIControlStateNormal];
    [noticeBtn addTarget:self action:@selector(gotoNoticeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noticeBtn];
    [noticeBtn.titleLabel sizeToFit];
    _noticeLabel = noticeLabel;
    _noticeBtn = noticeBtn;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginByWechatDidCancelled) name:WDGAppSigninWechatDidcancelledByUser object:nil];
}

-(UILabel *)pingfangLabelWithText:(NSString *)text size:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.text =text;
    label.textColor = [UIColor colorWithRed:0x66/255. green:0x66/255. blue:0x66/255. alpha:1];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    [label sizeToFit];
    return label;
}

-(void)loginByWechatDidCancelled
{
    [self.view hideHUDAnimate:NO];
    [self.view showHUDWithMessage:@"登录取消" hideAfter:.5 animate:YES];
}

-(void)login
{
    if([WXApi isWXAppInstalled] && WDGAppUseWechatLogin){
        self.loginByWechat =YES;
        [self.view showHUDAnimate:YES];
        SendAuthReq *req = [SendAuthReq new];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"osc_wechat_login" ;
        // 第三方向微信终端发送一个 SendAuthReq 消息结构
        [WXApi sendReq:req];
    }else
    [WDGLoginManager loginByTouristComplete:^{
        [UIApplication sharedApplication].delegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    }];
}

-(void)gotoNoticeVC
{
    [self.navigationController pushViewController:[WDGUserNoticeViewController new] animated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _noticeBtn.frame = _noticeBtn.titleLabel.bounds;
    _noticeLabel.center = CGPointMake(self.view.center.x-_noticeBtn.frame.size.width/2, self.view.frame.size.height-15-CGRectGetHeight(_noticeLabel.frame)/2);
    _noticeBtn.center = CGPointMake(self.view.center.x+_noticeLabel.frame.size.width/2, CGRectGetMidY(_noticeLabel.frame));
    _noticeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"loginViewController dealloc");
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end
