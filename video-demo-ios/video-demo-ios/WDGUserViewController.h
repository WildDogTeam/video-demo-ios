//
//  WDGUserViewController.h
//  video-demo-ios
//
//  Created by han wp on 2017/10/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGVideoUserItem;
@interface WDGUserViewController : UIViewController
+(instancetype)controllerWithUserItem:(WDGVideoUserItem *)userItem;
@end
