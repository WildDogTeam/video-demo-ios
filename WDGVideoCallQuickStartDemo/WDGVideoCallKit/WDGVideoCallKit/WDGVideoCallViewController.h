//
//  WDGVideoCallViewController.h
//  WDGVideoKit
//
//  Created by han wp on 2017/11/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGVideoControllerConfig;
@interface WDGVideoCallViewController : UIViewController
+(instancetype)controllerForConfig:(WDGVideoControllerConfig *)config;
@end
