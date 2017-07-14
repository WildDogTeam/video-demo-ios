//
//  UIView+MBProgressHud.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "UIView+MBProgressHud.h"
#import <MBProgressHUD/MBProgressHUD.h>
@implementation UIView (MBProgressHud)
-(void)showHUDWithMessage:(NSString *)message hideAfter:(int)time animate:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = message;
    [hud hideAnimated:animated afterDelay:time];
}
@end
