//
//  WDGTimer.h
//  video-demo-ios
//
//  Created by han wp on 2017/9/28.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGTimer : NSObject
+ (instancetype)timerWithstart:(NSTimeInterval)start interval:(NSTimeInterval)timeInterval block:(void (^)(NSTimeInterval timeInterval))block;
+ (instancetype)timeWithInterval:(NSTimeInterval)interval block:(void (^)(NSTimeInterval timeInterval))block;
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo;
- (void)invalidate;
@end
