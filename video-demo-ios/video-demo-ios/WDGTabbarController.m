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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cancelTitleRender];
    // Do any additional setup after loading the view.
}

-(void)cancelTitleRender
{
    NSMutableDictionary * normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] =  [UIFont fontWithName:@"PingFang SC" size:12];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary * selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSFontAttributeName] =  [UIFont fontWithName:@"PingFang SC" size:12];
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


@end
