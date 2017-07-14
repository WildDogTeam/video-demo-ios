//
//  WDGVideoConfig.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WilddogVideo/WDGVideoLocalStreamOptions.h>

#define WDGVideoConstraints360P @"360p"
#define WDGVideoConstraints480P @"480p"
#define WDGVideoConstraints720P @"720p"
#define WDGVideoConstraints1080P @"1080p"



@interface WDGVideoConfig : NSObject

+(void)setVideoConstraints:(NSString *)constraints;
+(WDGVideoConstraints)videoConstraintsNum;
+(NSString *)videoConstraints;

+(void)setBeautyPlan:(NSString *)plan;
+(NSString *)beautyPlan;
@end
