//
//  WDGiPhoneXAdapter.h
//  video-demo-ios
//
//  Created by wilddog on 2017/11/30.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  WDG_ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  WDG_ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  WDG_iPhoneX (((WDG_ScreenWidth == 812.f && WDG_ScreenHeight == 375.f)||((WDG_ScreenWidth == 375.f && WDG_ScreenHeight ==812.f ))) ? YES : NO)
#define WDG_ViewSafeAreInsets ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
#define  WDG_StatusbarHeight  (WDG_iPhoneX?0:20)

#define WDG_ViewSafeAreInsetsTop WDG_ViewSafeAreInsets.top
#define WDG_ViewSafeAreInsetsLeft WDG_ViewSafeAreInsets.left
#define WDG_ViewSafeAreInsetsBottom WDG_ViewSafeAreInsets.bottom
#define WDG_ViewSafeAreInsetsRight WDG_ViewSafeAreInsets.right
