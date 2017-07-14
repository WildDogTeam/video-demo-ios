//
//  WDGVideoConference.h
//  WilddogVideo
//
//  Created by Zheng Li on 11/4/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDGVideoConnectOptions.h"

@class WDGVideoLocalParticipant;
@class WDGVideoParticipant;
@class WDGVideoMeetingCast;
@protocol WDGVideoConferenceDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 表示连接的会议，同一时间只能连接到一个会议中。
 */
@interface WDGVideoConference : NSObject

/**
 表示当前会议的编号。
 */
@property (nonatomic, strong, readonly) NSString *ID;

/**
 `WDGVideoConnectionStatus` 类型，表示会议的状态。
 */
@property (nonatomic, assign, readonly) WDGVideoConnectionStatus status;

/**
 表示当前视频会议的本地参与者。
 */
@property (nonatomic, strong, readonly) WDGVideoLocalParticipant *localParticipant;

/**
 表示除自己外，已加入视频会议的参与者。
 */
@property (nonatomic, strong, readonly) NSArray<WDGVideoParticipant *> *participants;


/**
 `WDGVideoMeetingCast` 类型，用于查看并控制当前视频会议的直播状态。当野狗控制台中未开启直播推流功能时该属性为 nil。当会议未处于 `WDGVideoConnectionStatusConnected` 状态时该属性为 nil。
 */
@property (nonatomic, strong, readonly, nullable) WDGVideoMeetingCast *meetingCast;


/**
 符合 `WDGVideoConferenceDelegate` 协议的代理。
 */
@property (nonatomic, weak, nullable) id<WDGVideoConferenceDelegate> delegate;

/**
 命令同当前会议断开连接。
 */
- (void)disconnect;

/**
 依据会议参与者的 Wilddog ID 获取对应的 `WDGVideoParticipant` 模型。

 @param participantID 会议参与者的 Wilddog ID。

 @return `WDGVideoParticipant` 实例，若未找到相应参与者，返回 nil。
 */
- (WDGVideoParticipant *_Nullable)getParticipant:(NSString *)participantID;

@end

/**
 `WDGVideoConference` 的代理方法。
 */
@protocol WDGVideoConferenceDelegate <NSObject>
@optional

/**
 `WDGVideoConference` 通过调用该方法通知代理已与当前视频会议建立连接。

 @param conference 调用该方法的 `WDGVideoConference` 实例。
 */
- (void)conferenceDidConnected:(WDGVideoConference *)conference;

/**
 `WDGVideoConference` 通过调用该方法通知代理未能与当前视频会议建立连接。

 @param conference 调用该方法的 `WDGVideoConference` 实例。
 @param error 错误信息，描述未能建立连接的原因。
 */
- (void)conference:(WDGVideoConference *)conference didFailedToConnectWithError:(NSError *)error;

/**
 `WDGVideoConference` 通过调用该方法通知代理已与当前视频会议断开连接。

 @param conference 调用该方法的 `WDGVideoConference` 实例。
 @param error 错误信息，描述连接断开的原因。本地主动断开连接时为 nil。
 */
- (void)conference:(WDGVideoConference *)conference didDisconnectWithError:(NSError *_Nullable)error;

/**
 `WDGVideoConference` 通过调用该方法通知代理当前视频会议有新的参与者加入。

 @param conference 调用该方法的 `WDGVideoConference` 实例。
 @param participant 代表新的参与者的 `WDGVideoParticipant` 实例。
 */
- (void)conference:(WDGVideoConference *)conference didConnectParticipant:(WDGVideoParticipant *)participant;

/**
 `WDGVideoConference` 通过调用该方法通知代理当前视频会议某个参与者断开了连接。

 @param conference 调用该方法的 `WDGVideoConference` 实例。
 @param participant 代表已断开连接的参与者的 `WDGVideoParticipant` 实例。
 */
- (void)conference:(WDGVideoConference *)conference didDisconnectParticipant:(WDGVideoParticipant *)participant;

@end

NS_ASSUME_NONNULL_END
