//
//  WDGVideoLocalStreamStatsReport.h
//  WilddogVideo
//
//  Created by Zheng Li on 28/04/2017.
//  Copyright © 2017 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 本地视频流的统计信息。
 */
@interface WDGVideoLocalStreamStatsReport : NSObject

/**
 视频的宽度，以像素为单位。
 */
@property (nonatomic, assign, readonly) NSUInteger width;

/**
 视频的高度，以像素为单位。
 */
@property (nonatomic, assign, readonly) NSUInteger height;

/**
 视频的帧率。
 */
@property (nonatomic, assign, readonly) NSUInteger FPS;

/**
 本地视频流已发送的字节数。
 */
@property (nonatomic, assign, readonly) int64_t bytesSent;

/**
 本地视频流的发送速率，以 kbps 为单位。
 */
@property (nonatomic, assign, readonly) NSUInteger bitsSentRate;

@end

NS_ASSUME_NONNULL_END
