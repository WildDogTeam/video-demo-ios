
//
//  WDGVideoConfig.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoConfig.h"

#define WDGVideoDimension @[WDGVideoDimensions360p,WDGVideoDimensions480p,WDGVideoDimensions720p,WDGVideoDimensions1080p]
#define WDGVideoConstraintsKey @"com.wilddog.video.constraints"
#define WDGVideoBeautyPlanKey @"com.wilddog.video.beautyPlan"

@implementation WDGVideoConfig

static NSString *_beautyPlan;
static NSString *_videoConstraints;
+(void)setVideoConstraints:(NSString *)constraints
{
    _videoConstraints =constraints;
    [[NSUserDefaults standardUserDefaults] setObject:_videoConstraints forKey:WDGVideoConstraintsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(WDGVideoDimensions)videoConstraintsNum
{
    return [WDGVideoDimension indexOfObject:[self videoDimensions]];
}

+(NSString *)videoDimensions
{
    if(!_videoConstraints){
        _videoConstraints = [[NSUserDefaults standardUserDefaults] objectForKey:WDGVideoConstraintsKey];
        if(!_videoConstraints){
            _videoConstraints = @"360p";
        }
    }
    return _videoConstraints;
}

+(void)setBeautyPlan:(NSString *)plan
{
    _beautyPlan =plan;
    [[NSUserDefaults standardUserDefaults] setObject:_beautyPlan forKey:WDGVideoBeautyPlanKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)beautyPlan
{
    if(!_beautyPlan){
        _beautyPlan = [[NSUserDefaults standardUserDefaults] objectForKey:WDGVideoBeautyPlanKey];
        if(!_beautyPlan){
            _beautyPlan = @"Camera360";
        }
    }
    return _beautyPlan?:@"";
}
@end
