//
//  WDGTimer.h
//  video-demo-ios
//
//  Created by han wp on 2017/9/28.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGTimer : NSObject
+(NSTimer *)timerWithstart:(NSTimeInterval)start interval:(NSTimeInterval)timeInterval block:(void (^)(NSTimeInterval timeInterval))block;
@end
