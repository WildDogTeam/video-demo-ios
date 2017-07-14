//
//  WDGVideoConnectOptions.h
//  WilddogVideo
//
//  Created by Zheng Li on 11/7/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGVideoLocalStream;

/**
 表示视频通话或会议的连接状态。

 - WDGVideoConnectionStatusConnecting: 表示视频通话或会议正在连接中。
 - WDGVideoConnectionStatusConnected: 表示视频通话或会议已连接。
 - WDGVideoConnectionStatusDisconnected: 表示视频通话或会议已断开连接。
 */
typedef NS_ENUM(NSUInteger, WDGVideoConnectionStatus) {
    WDGVideoConnectionStatusConnecting = 0,
    WDGVideoConnectionStatusConnected,
    WDGVideoConnectionStatusDisconnected,
};

NS_ASSUME_NONNULL_BEGIN

/**
 发起视频通话或连接到会议时使用的配置选项。
 */
@interface WDGVideoConnectOptions : NSObject

/**
 发起视频通话或连接到会议时使用的本地媒体流。
 */
@property (nonatomic, strong) WDGVideoLocalStream *localStream;

/**
 可选，自定义字符串。发起视频通话时，被邀请者将在 `WDGVideoIncomingInvite` 对象中得到该数据。连接会议时，该数据发往后端服务器。
 */
@property (nonatomic, strong, nullable) NSString *userData;

/**
 初始化 `WDGVideoConnectOptions` 对象。

 @param localStream `WDGVideoLocalStream` 类型的本地媒体流对象。
 @return `WDGVideoConnectOptions` 对象。
 */
- (nullable instancetype)initWithLocalStream:(WDGVideoLocalStream *)localStream;

@end

NS_ASSUME_NONNULL_END
