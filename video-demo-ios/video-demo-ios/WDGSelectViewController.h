//
//  WDGSelectViewController.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SelectStyle){
    SelectStyleDefinition =1,
    SelectStyleBeauty
};

@interface WDGSelectViewController : UIViewController
@property (nonatomic, assign) SelectStyle style;
@property (nonatomic, copy) void(^complete)(NSString *ans);
@end
