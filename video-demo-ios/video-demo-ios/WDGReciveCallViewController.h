//
//  WDGReciveCallViewController.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGReciveCallViewController : UIViewController
+(instancetype)controllerWithCallerID:(NSString *)ID userAccept:(void (^)(BOOL))accept;
@end
