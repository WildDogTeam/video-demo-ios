//
//  UIView+MBProgressHud.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MBProgressHud)
-(void)showHUDWithMessage:(NSString *)message hideAfter:(int)time animate:(BOOL)animated;
@end
