//
//  WDGVideoErrors.h
//  WilddogVideo
//
//  Created by Zheng Li on 9/8/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef WDG_ERROR_ENUM

#if __has_attribute(ns_error_domain) && (!__cplusplus || __cplusplus >= 201103L)
#define WDG_ERROR_ENUM(type, name, domain)                               \
    _Pragma("clang diagnostic push")                                     \
        _Pragma("clang diagnostic ignored \"-Wignored-attributes\"")     \
            NS_ENUM(type, __attribute__((ns_error_domain(domain))) name) \
                _Pragma("clang diagnostic pop")
#else
#define WDG_ERROR_ENUM(type, name, domain) NS_ENUM(type, name)
#endif

#endif

NS_ASSUME_NONNULL_BEGIN

extern NSString *const WDGVideoErrorDomain;

/**
 WilddogVideo 使用的错误码。
 */
typedef WDG_ERROR_ENUM(NSInteger, WDGVideoError, WDGVideoErrorDomain){
    /**
     未知错误
     */
    WDGVideoErrorUnknown = 40000,

    /**
     输入参数无效
     @note: 详细信息见 `localizedDescription` 字段
     */
    WDGVideoErrorInvalidArgument = 40001,

    /**
     无摄像头或麦克风权限
     */
    WDGVideoErrorDeviceNotAvailable = 40002,

    /**
     参与者无法建立连接
     */
    WDGVideoErrorConnectFailed = 40003,

    /**
     参与者连接失败
     */
    WDGVideoErrorConnectionDisconnected = 40004,

    /**
     视频通话和会议的数量超过上限
     */
    WDGVideoErrorTooManyActiveConnections = 40005,

    /**
     Client初始化失败，Video 功能未开启或已停用
     */
    WDGVideoErrorClientRegistrationFailed = 40101,

    /**
     Client初始化失败，Auth token 过期
     */
    WDGVideoErrorInvalidAuthArgument = 40102,

    /**
     Conversation 创建失败，未在控制面板中开启功能
     */
    WDGVideoErrorConversationRegistrationFailed = 40201,

    /**
     视频通话邀请发起失败
     */
    WDGVideoErrorConversationInvitationFailed = 40202,

    /**
     视频通话邀请被拒绝
     */
    WDGVideoErrorConversationInvitationRejected = 40203,

    /**
     被邀请者繁忙，不能响应邀请
     */
    WDGVideoErrorConversationInvitationIgnored = 40204,

    /**
     Conference 连接失败，未在控制面板中开启功能
     */
    WDGVideoErrorConferenceRegistrationFailed = 40301,

    /**
     视频会议人数超过上限
     */
    WDGVideoErrorConferenceTooManyParticipants = 40302,

    /**
     MeetingCast 初始化失败，未在控制面板中开启功能
     */
    WDGVideoErrorMeetingCastRegistrationFailed = 40311,

    /**
     MeetingCast 操作冲突，当前已经开启 MeetingCast
     */
    WDGVideoErrorMeetingCastStartFailed = 40312,

    /**
     MeetingCast 切换参与者失败，未开启 MeetingCast 或切换失败
     */
    WDGVideoErrorMeetingCastSwitchFailed = 40313,

    /**
     MeetingCast 停止直播操作失败
     */
    WDGVideoErrorMeetingCastStopFailed = 40314,

    /**
     无法与参与者建立连接
     */
    WDGVideoErrorParticipantConnectFailed = 40401,

    /**
     参与者连接失败
     */
    WDGVideoErrorParticipantConnectionDisconnected = 40402};

NS_ASSUME_NONNULL_END
