//
//  WDGBeautyManager.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/13.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGBeautyManager.h"
#import "WDGBeautyOption.h"
@implementation WDGBeautyManager
+(instancetype)sharedManager
{
    static WDGBeautyManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [WDGBeautyManager new];
        _manager.option = [[NSClassFromString(@"WDGCamera360Option") alloc] init];
    });
    return _manager;
}

-(CVPixelBufferRef)proccessPixelBuffer:(CVPixelBufferRef)buffer
{
    return [_option proccessPixelBuffer:buffer];
}
@end
