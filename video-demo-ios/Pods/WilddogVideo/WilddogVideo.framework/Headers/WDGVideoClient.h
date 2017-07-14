//
//  WDGVideo.h
//  WilddogVideo
//
//  Created by Zheng Li on 8/19/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDGVideoInvite.h"

@class WDGApp;
@class WDGVideoClientOptions;
@class WDGVideoConnectOptions;
@class WDGVideoConversation;
@class WDGVideoConference;
@class WDGVideoIncomingInvite;
@class WDGVideoOutgoingInvite;
@protocol WDGVideoClientDelegate;
@protocol WDGVideoConferenceDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 用于创建本地流，发起、加入视频通话。
 */
@interface WDGVideoClient : NSObject

/**
 符合 `WDGVideoClientDelegate` 协议的代理，用于处理视频通话邀请消息。
 */
@property (nonatomic, weak, nullable) id<WDGVideoClientDelegate> delegate;

/**
 Client 对应的 Wilddog ID。
 */
@property (nonatomic, strong, readonly) NSString *uid;

/**
 继承自NSObject的初始化方法不可用。

 @return 无效的 `WDGVideoClient` 实例。
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化 `WDGVideoClient` 实例。在初始化前需要先通过 `WDGAuth` 登录。

 @param app `WDGApp` 对象。
 @return `WDGVideoClient` 实例，若初始化失败返回nil。
 */
- (nullable instancetype)initWithApp:(WDGApp *)app;

/**
 初始化 `WDGVideoClient` 实例。在初始化前需要先通过 `WDGAuth` 登录。

 @param app `WDGApp` 对象。
 @param options 配置选项。
 @return `WDGVideoClient` 实例，若初始化失败返回nil。
 */
- (nullable instancetype)initWithApp:(WDGApp *)app options:(WDGVideoClientOptions *)options NS_DESIGNATED_INITIALIZER;

/**
 邀请其他用户进行视频通话。

 @param participantID     被邀请者的 Wilddog ID。
 @param options           邀请成功时使用该配置项创建通话。
 @param completionHandler 当邀请得到回应后，SDK 通过该闭包通知邀请结果，若对方接受邀请，在闭包中返回 `WDGVideoConversation` 实例，否则将在闭包中返回 `NSError` 说明邀请失败的原因。

 @return `WDGVideoOutgoingInvite` 实例，可用于取消此次邀请。
 */
- (WDGVideoOutgoingInvite *_Nullable)inviteToConversationWithID:(NSString *)participantID options:(WDGVideoConnectOptions *)options completion:(WDGVideoInviteAcceptanceBlock)completionHandler;

/**
 连接到 ID 为 `conferenceID` 的会议中。

 @param conferenceID 连接的会议 ID。
 @param options `WDGVideoConnectOptions` 实例，用于配置连接会议所用的选项。
 @param delegate 满足 `WDGVideoConferenceDelegate` 协议的代理。
 @return `WDGVideoConference` 实例。
 */
- (WDGVideoConference *)connectToConferenceWithID:(NSString *)conferenceID options:(WDGVideoConnectOptions *)options delegate:(id<WDGVideoConferenceDelegate>)delegate;

@end

/**
 `WDGVideoClient` 的代理方法。
 */
@protocol WDGVideoClientDelegate <NSObject>
@optional

/**
 `WDGVideoClient` 通过调用该方法通知当前用户收到新的视频通话邀请。

 @param videoClient 调用该方法的 `WDGVideoClient` 实例。
 @param invite      代表收到的邀请的 `WDGVideoIncomingInvite` 实例。
 */
- (void)wilddogVideoClient:(WDGVideoClient *)videoClient didReceiveInvite:(WDGVideoIncomingInvite *)invite;

/**
 `WDGVideoClient` 通过调用该方法通知当前用户之前收到的某个邀请被邀请者取消。

 @param videoClient 调用该方法的 `WDGVideoClient` 实例。
 @param invite      代表被取消的邀请的 `WDGVideoIncomingInvite` 实例。
 */
- (void)wilddogVideoClient:(WDGVideoClient *)videoClient inviteDidCancel:(WDGVideoIncomingInvite *)invite;

@end

NS_ASSUME_NONNULL_END
