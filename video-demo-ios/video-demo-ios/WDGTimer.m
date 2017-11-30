//
//  WDGTimer.m
//  video-demo-ios
//
//  Created by han wp on 2017/9/28.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGTimer.h"

@implementation WDGTimer
{
    void (^_timerBlock)(NSTimeInterval timeInterval);
    NSTimeInterval _currentTime;
    NSTimer *_timer;
    NSTimeInterval _interval;
}
+(NSTimer *)timerWithstart:(NSTimeInterval)start interval:(NSTimeInterval)timeInterval block:(void (^)(NSTimeInterval timeInterval))block
{
    WDGTimer *timer =[self new];
    NSTimeInterval interval = timeInterval>0?timeInterval:-timeInterval;
    timer->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(calculate:) userInfo:nil repeats:YES];
    timer->_currentTime = start;
    timer->_interval =timeInterval;
    timer->_timerBlock = [block copy];
    timer->_timerBlock(start);
 //   dispatch_async(dispatch_get_global_queue(0, 0), ^{
   //     [[NSRunLoop currentRunLoop] addTimer:timer->_timer forMode:NSRunLoopCommonModes];
  //      [[NSRunLoop currentRunLoop] run];
//    });
    return timer->_timer;
}

-(void)calculate:(NSTimer *)timer
{
    _currentTime+=_interval;
    _timerBlock(_currentTime);
}
@end
