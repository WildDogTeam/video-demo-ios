//
//  WDGVideoLocalStream.h
//  WilddogVideo
//
//  Created by Zheng Li on 8/23/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import "WDGVideoStream.h"

@class WDGVideoLocalStreamOptions;
@class WDGVideoLocalStream;

NS_ASSUME_NONNULL_BEGIN


/**
 处理视频流并返回。视频流格式为 'kCVPixelFormatType_420YpCbCr8BiPlanarFullRange'。
 如果返回空，则丢弃当前帧图片。
 */
@protocol WDGVideoLocalStreamDelegate <NSObject>

@optional
- (CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

/**
 `WDGVideoLocalStream` 继承自 `WDGVideoStream` ，具有 `WDGVideoStream` 所有的方法。
 */
@interface WDGVideoLocalStream : WDGVideoStream

@property (weak, nonatomic, nullable) id<WDGVideoLocalStreamDelegate> delegate;

/**
 继承自 `NSObject` 的初始化方法不可用。

 @return 无效的 `WDGVideoLocalStream` 实例。
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 依照配置创建一个本地视频流。同一时刻只能存在一个本地视频流，若此时已经创建其他视频流，会返回 nil。

 @param options `WDGVideoLocalStreamOptions` 实例。
 @return 创建的本地视频流 `WDGVideoLocalStream` 实例。
 */
- (nullable instancetype)initWithOptions:(WDGVideoLocalStreamOptions *)options NS_DESIGNATED_INITIALIZER;

/**
 切换摄像头。
 */
- (void)switchCamera;

@end

NS_ASSUME_NONNULL_END
