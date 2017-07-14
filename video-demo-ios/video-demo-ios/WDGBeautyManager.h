//
//  WDGBeautyManager.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/13.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
@class WDGBeautyOption;

@interface WDGBeautyManager : NSObject
+(instancetype)sharedManager;
@property (nonatomic,strong) WDGBeautyOption *option;
- (CVPixelBufferRef)proccessPixelBuffer:(CVPixelBufferRef)buffer;
@end
