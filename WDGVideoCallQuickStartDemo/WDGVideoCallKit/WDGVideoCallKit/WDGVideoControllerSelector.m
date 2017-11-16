//
//  WDGVIdeoControllerSelector.m
//  WDGVideoKit
//
//  Created by han wp on 2017/10/12.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoControllerSelector.h"
#import "WDGVideoCallViewController.h"
#import "WDGVideoControllerConfig.h"

@implementation WDGVideoControllerSelector
+(void)showVideoControllerWithConfig:(WDGVideoControllerConfig *)config
{
    UIViewController *controller = [WDGVideoCallViewController controllerForConfig:config];
    [[self getTopController] presentViewController:controller animated:YES completion:nil];
}

+(UIViewController *)getTopController
{
    UIViewController *topController =[UIApplication sharedApplication].delegate.window.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}
@end
