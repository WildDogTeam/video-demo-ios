//
//  WDGRegardViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGRegardViewController.h"

#define WDGVideoCallSDKVersion @"2.4.1"
#define WDGVideoRoomSDKVersion @"2.2.3"
#define WDGSyncSDKVersion @"2.3.11"
#define WDGAuthSDKVersion @"2.0.7"
#define Camera360SDKVersion @"1.6"
#define TUSDKVersion @"2.2"


@interface WDGRegardViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WDGRegardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMyView];
}

-(void)createMyView
{
    CGFloat centerX = self.view.bounds.size.width*.5;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glyphs"]];
    imageView.frame = CGRectMake(0, 0, 49, 49);
    imageView.center = CGPointMake(centerX, 25+90);
    [self.view addSubview:imageView];
    
    UILabel *titleLabel = [self pingfangLabelWithText:@"野狗视频通话"];
    titleLabel.textColor = [UIColor colorWithRed:0x33/255. green:0x33/255. blue:0x33/255. alpha:1];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(centerX, CGRectGetMaxY(imageView.frame)+9+CGRectGetHeight(titleLabel.frame)*.5);
    [self.view addSubview:titleLabel];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLabel = [self pingfangLabelWithText:[NSString stringWithFormat:@"V%@",appVersion]];
    versionLabel.textColor = [UIColor colorWithRed:0x33/255. green:0x33/255. blue:0x33/255. alpha:1];
    versionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [versionLabel sizeToFit];
    versionLabel.center = CGPointMake(CGRectGetMidX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+CGRectGetHeight(versionLabel.frame)*.5);
    [self.view addSubview:versionLabel];
    
    UILabel *detailLabel = [self pingfangLabelWithText:@"该应用程序基于"];
    detailLabel.center = CGPointMake(centerX, CGRectGetMaxY(versionLabel.frame)+37+CGRectGetHeight(detailLabel.frame)*.5);
    [self.view addSubview:detailLabel];
    
    CGFloat gap = 10;
    UILabel *videoCallLabel = [self pingfangLabelWithText:[NSString stringWithFormat:@"Wilddog VideoCall SDK v%@",WDGVideoCallSDKVersion]];
    videoCallLabel.center = CGPointMake(centerX, CGRectGetMaxY(detailLabel.frame)+gap+CGRectGetHeight(videoCallLabel.frame)*.5);
    [self.view addSubview:videoCallLabel];
    UILabel *videoRoomLabel = [self pingfangLabelWithText:[NSString stringWithFormat:@"Wilddog VideoRoom SDK v%@",WDGVideoRoomSDKVersion]];
    videoRoomLabel.center = CGPointMake(centerX, CGRectGetMaxY(videoCallLabel.frame)+gap+CGRectGetHeight(videoRoomLabel.frame)*.5);
    [self.view addSubview:videoRoomLabel];
    UILabel *syncLabel = [self pingfangLabelWithText:[NSString stringWithFormat:@"Wilddog Sync SDK v%@",WDGSyncSDKVersion]];
    syncLabel.center = CGPointMake(centerX, CGRectGetMaxY(videoRoomLabel.frame)+gap+CGRectGetHeight(syncLabel.frame)*.5);
    [self.view addSubview:syncLabel];
    UILabel *authLabel = [self pingfangLabelWithText:[NSString stringWithFormat:@"Wilddog Auth SDK v%@",WDGAuthSDKVersion]];
    authLabel.center = CGPointMake(centerX, CGRectGetMaxY(syncLabel.frame)+gap+CGRectGetHeight(authLabel.frame)*.5);
    [self.view addSubview:authLabel];
    UILabel *camera360Label = [self pingfangLabelWithText:[NSString stringWithFormat:@"Camera360 SDK v%@",Camera360SDKVersion]];
    camera360Label.center = CGPointMake(centerX, CGRectGetMaxY(authLabel.frame)+gap+CGRectGetHeight(camera360Label.frame)*.5);
    [self.view addSubview:camera360Label];
    UILabel *tusdkLabel = [self pingfangLabelWithText:[NSString stringWithFormat:@"TuSDK v%@",TUSDKVersion]];
    tusdkLabel.center = CGPointMake(centerX, CGRectGetMaxY(camera360Label.frame)+gap+CGRectGetHeight(tusdkLabel.frame)*.5);
    [self.view addSubview:tusdkLabel];
}

-(UILabel *)pingfangLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text =text;
    label.textColor = [UIColor colorWithRed:0x66/255. green:0x66/255. blue:0x66/255. alpha:1];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [label sizeToFit];
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)goback:(UIBarButtonItem *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}


@end
