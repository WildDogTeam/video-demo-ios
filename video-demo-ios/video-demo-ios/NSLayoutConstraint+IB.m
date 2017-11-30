//
//  NSLayoutConstraint+IB.m
//  video-demo-ios
//
//  Created by han wp on 2017/11/29.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "NSLayoutConstraint+IB.h"
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen]currentMode].size) : NO)
//适配参数
#define KsuitParam (kDevice_Is_iPhone6Plus ?1.12:(kDevice_Is_iPhone6?1.0:(iPhone6PlusBigMode ?1.01:0.85))) //以6为基准图

@implementation NSLayoutConstraint (IB)
- (void)setAdapterScreen:(int)adapterScreen{
        self.constant = self.constant * KsuitParam;
    
}

-(int)adapterScreen
{
    return 0;
}

@end
