//
//  WDGUserNoticeViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/9/29.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGUserNoticeViewController.h"

@interface WDGUserNoticeViewController()<UIGestureRecognizerDelegate>
@end

@implementation WDGUserNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets =NO;
    self.navigationController.navigationBar.translucent =NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]};
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"用户协议";
    UIBarButtonItem *gobackItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左箭头"] style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = gobackItem;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"《野狗视频通话用户协议》" ofType:@"docx"]]]];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.navigationController.viewControllers.count > 1;
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
