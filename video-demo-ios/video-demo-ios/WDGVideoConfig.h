//
//  WDGVideoConfig.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WilddogVideoBase/WDGLocalStreamOptions.h>

#define WDGVideoDimensions360p @"360p"
#define WDGVideoDimensions480p @"480p"
#define WDGVideoDimensions720p @"720p"
#define WDGVideoDimensions1080p @"1080p"



@interface WDGVideoConfig : NSObject

+(void)setVideoConstraints:(NSString *)constraints;
+(WDGVideoDimensions)videoConstraintsNum;
+(NSString *)videoConstraints;

+(void)setBeautyPlan:(NSString *)plan;
+(NSString *)beautyPlan;
@end
