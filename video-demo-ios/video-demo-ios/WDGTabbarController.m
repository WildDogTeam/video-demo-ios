//
//  WDGTabbarController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/6/21.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGTabbarController.h"
#define WilddogDemoTabbarHeight 57
@interface WDGTabbarController ()

@end

@implementation WDGTabbarController
{
    BOOL _maskportrait;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _maskportrait=YES;
    [self cancelTitleRender];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maskportrait) name:@"maskportrait" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MaskLandscapeRight) name:@"masklandscaperight" object:nil];
}

-(void)maskportrait
{
    _maskportrait =YES;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

-(void)MaskLandscapeRight
{
    _maskportrait =NO;
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

-(void)cancelTitleRender
{
    NSMutableDictionary * normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary * selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSFontAttributeName] =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    selectAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    UITabBarItem * item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect frame = self.tabBar.frame;
        frame.size.height = WilddogDemoTabbarHeight;
        frame.origin.y-= (WilddogDemoTabbarHeight-49);
        self.tabBar.frame = frame;
    });
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _maskportrait?UIInterfaceOrientationMaskPortrait:UIInterfaceOrientationMaskLandscapeRight;
}

@end
