//
//  WDGLoginManager.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGLoginManager : NSObject
+(BOOL)hasLogin;
+(void)loginByTouristComplete:(void (^)())complete;
+(void)logOut;
+(UIViewController *)switchRootViewController;
@end
