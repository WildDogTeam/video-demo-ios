//
//  WDGBeautyOption.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/13.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@interface WDGBeautyOption : NSObject
- (CVPixelBufferRef)proccessPixelBuffer:(CVPixelBufferRef)buffer;
@end
