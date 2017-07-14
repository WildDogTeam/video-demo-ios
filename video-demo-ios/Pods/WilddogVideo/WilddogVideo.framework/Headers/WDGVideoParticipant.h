//
//  WDGVideoParticipant.h
//  WilddogVideo
//
//  Created by Zheng Li on 9/8/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGVideoRemoteStream;
@protocol WDGVideoParticipantDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 代表视频通话或视频会议的一个参与者。
 */
@interface WDGVideoParticipant : NSObject

/**
 该参与者的 Wilddog ID。
 */
@property (nonatomic, strong, readonly) NSString *ID;

/**
 该参与者发布的媒体流。
 */
@property (nonatomic, strong, readonly, nullable) WDGVideoRemoteStream *stream;

/**
 符合 `WDGVideoParticipantDelegate` 协议的代理。
 */
@property (nonatomic, weak, nullable) id<WDGVideoParticipantDelegate> delegate;

@end

/**
 `WDGVideoParticipant` 的代理方法。
 */
@protocol WDGVideoParticipantDelegate <NSObject>
@optional

/**
 `WDGVideoParticipant` 通过该方法通知代理收到参与者发布的媒体流。

 @param participant `WDGVideoParticipant` 对象，代表当前参与者。
 @param stream `WDGVideoRemoteStream` 对象，代表收到的媒体流。
 */
- (void)participant:(WDGVideoParticipant *)participant didAddStream:(WDGVideoRemoteStream *)stream;

/**
 `WDGVideoParticipant` 通过该方法通知代理未能收到参与者发布的媒体流。

 @param participant `WDGVideoParticipant` 对象，代表当前参与者。
 @param error 错误信息，描述连接失败的原因。
 */
- (void)participant:(WDGVideoParticipant *)participant didFailedToConnectWithError:(NSError *)error;


/**
 `WDGVideoParticipant` 通过该方法通知代理参与者的媒体流中断。

 @param participant `WDGVideoParticipant` 对象，代表当前参与者。
 @param error 错误信息，描述媒体流中断的原因。
 */
- (void)participant:(WDGVideoParticipant *)participant didDisconnectWithError:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
