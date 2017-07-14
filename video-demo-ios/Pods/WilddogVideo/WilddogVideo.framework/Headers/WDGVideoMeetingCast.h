//
//  WDGVideoMeetingCast.h
//  WilddogVideo
//
//  Created by Zheng Li on 9/21/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGVideoConference;
@protocol WDGVideoMeetingCastDelegate;

/**
 代表当前直播状态

 - WDGVideoMeetingCastStatusOff: 表示直播未开启或已关闭
 - WDGVideoMeetingCastStatusOn: 表示直播正在进行中
 */
typedef NS_ENUM(NSUInteger, WDGVideoMeetingCastStatus) {
    WDGVideoMeetingCastStatusOff,
    WDGVideoMeetingCastStatusOn,
};

NS_ASSUME_NONNULL_BEGIN

/**
 用于控制视频会议的直播状态。
 */
@interface WDGVideoMeetingCast : NSObject

/**
 表明当前直播的状态。
 */
@property (nonatomic, assign, readonly) WDGVideoMeetingCastStatus status;

/**
 表明当前正在直播的参与者的 Wilddog ID。若当前没在直播，该属性为 nil。
 */
@property (nonatomic, strong, readonly, nullable) NSString *castingParticipantID;

/**
 符合 `WDGVideoMeetingCastDelegate` 协议的代理，负责处理直播相关的事件。
 */
@property (nonatomic, weak, nullable) id<WDGVideoMeetingCastDelegate> delegate;

/**
 开启直播。通过 `WDGVideoMeetingCastDelegate` 获得直播信息。

 @param participantID 开启直播，并直播 Wilddog ID 为 participantID 的参与者的媒体流。
 */
- (void)startWithParticipantID:(NSString *)participantID;

/**
 开启直播。通过 `WDGVideoMeetingCastDelegate` 获得直播信息。

 @param participantID 开启直播，并直播 Wilddog ID 为 participantID 的参与者的媒体流。
 @param completionHandler 操作完成时通过回调返回操作状态，若失败则通过 NSError 对象说明原因。
 */
- (void)startWithParticipantID:(NSString *)participantID completion:(void (^)(NSError *_Nullable error))completionHandler;

/**
 在直播开启后，切换直播视频流。通过 `WDGVideoMeetingCastDelegate` 获得直播信息。

 @param participantID 直播 Wilddog ID 为 participantID 的参与者的媒体流。
 */
- (void)switchToParticipantID:(NSString *)participantID;

/**
 在直播开启后，切换直播视频流。通过 `WDGVideoMeetingCastDelegate` 获得直播信息。

 @param participantID 直播 Wilddog ID 为 participantID 的参与者的媒体流。
 @param completionHandler 操作完成时通过回调返回操作状态，若失败则通过 NSError 对象说明原因。
 */
- (void)switchToParticipantID:(NSString *)participantID completion:(void (^)(NSError *_Nullable error))completionHandler;

/**
 关闭直播。
 */
- (void)stop;

/**
 关闭直播。

 @param completionHandler 操作完成时通过回调返回操作状态，若失败则通过 NSError 对象说明原因。
 */
- (void)stopWithCompletion:(void (^)(NSError *_Nullable error))completionHandler;

@end

/**
 MeetingCast 代理方法。
 */
@protocol WDGVideoMeetingCastDelegate <NSObject>

/**
 当前视频会议的直播状态发生变化时，通过该代理方法返回当前直播参与者的 Wilddog ID 与直播流的 URL 地址。

 @param meetingCast 当前 `WDGVideoMeetingCast` 实例。
 @param status 最新的直播状态。
 @param participantID 当前直播中的参与者的 Wilddog ID。
 @param castURLs 包含直播流的 URL 地址，字典的 Key 为直播流的种类，目前包含 `rtmp` 和 `hls` 两类，字典的 Value 为该直播流种类对应的地址。
 */
- (void)meetingCast:(WDGVideoMeetingCast *)meetingCast didUpdatedWithStatus:(WDGVideoMeetingCastStatus)status castingParticipantID:(NSString *_Nullable)participantID castURLs:(NSDictionary<NSString *, NSString *> *_Nullable)castURLs;

@end

NS_ASSUME_NONNULL_END
