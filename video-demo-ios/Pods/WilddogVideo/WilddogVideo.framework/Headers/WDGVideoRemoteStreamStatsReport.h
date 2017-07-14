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
 远程视频流的统计信息。
 */
@interface WDGVideoRemoteStreamStatsReport : NSObject

/**
 统计信息对应的用户信息。
 */
@property (nonatomic, strong, readonly) NSString *userID;

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
 远程视频流已接收的字节数。
 */
@property (nonatomic, assign, readonly) int64_t bytesReceived;

/**
 远程视频流的接收速率，以 kbps 为单位。
 */
@property (nonatomic, assign, readonly) NSUInteger bitsReceivedRate; // kbps

/**
 远程视频流的延迟，以毫秒为单位。
 */
@property (nonatomic, assign, readonly) NSUInteger delay;

@end

NS_ASSUME_NONNULL_END
