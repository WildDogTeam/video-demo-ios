//
//  WDGTimer.m
//  video-demo-ios
//
//  Created by han wp on 2017/9/28.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGTimer.h"

@interface WDGTimer()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSRunLoop *currentRunloop;
@property (nonatomic,copy) void (^timerBlock)(NSTimeInterval timeInterval);
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic) NSTimeInterval currentTime;
@end

@implementation WDGTimer

+(instancetype)timeWithInterval:(NSTimeInterval)interval block:(void (^)(NSTimeInterval))block
{
    return [self timerWithstart:0 interval:interval block:block];
}

+(instancetype)timerWithstart:(NSTimeInterval)start interval:(NSTimeInterval)timeInterval block:(void (^)(NSTimeInterval timeInterval))block
{
    return [[self alloc] initWithstart:start interval:timeInterval block:block];
}

+(instancetype)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo
{
    return [[self alloc] initWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo];
}

-(instancetype)initWithstart:(NSTimeInterval)start interval:(NSTimeInterval)timeInterval block:(void (^)(NSTimeInterval timeInterval))block
{
    if(self = [super init]){
        self.timerBlock = [block copy];
        self.currentTime = start;
        self.interval = timeInterval;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool{
                self.currentRunloop = [NSRunLoop currentRunLoop];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerCalculate) userInfo:nil repeats:YES];
                CFRunLoopRun();
            }
        });
    }
    return self;
}

-(instancetype)initWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo
{
    if(self = [super init]){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool{
                self.currentRunloop = [NSRunLoop currentRunLoop];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:YES];
                CFRunLoopRun();
            }
        });
    }
    return self;
}

-(void)timerCalculate
{
    _currentTime+=_interval;
    if(self.timerBlock){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timerBlock(self.currentTime);
        });
    }
}

-(void)invalidate
{
    [self.timer invalidate];
    CFRunLoopStop([self.currentRunloop getCFRunLoop]);
}

-(void)dealloc{
    NSLog(@"timer dealloc");
}

@end
