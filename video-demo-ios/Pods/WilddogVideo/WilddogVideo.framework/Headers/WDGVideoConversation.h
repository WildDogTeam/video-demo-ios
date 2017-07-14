//
//  WDGClient.h
//  WilddogVideo
//
//  Created by Zheng Li on 8/16/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDGVideoConnectOptions.h"

@class WDGSyncReference;
@class WDGVideoLocalParticipant;
@class WDGVideoRemoteStream;
@class WDGVideoOutgoingInvite;
@class WDGVideoParticipant;
@class WDGVideoLocalStreamStatsReport;
@class WDGVideoRemoteStreamStatsReport;

@protocol WDGVideoConversationDelegate;
@protocol WDGVideoConversationStatsDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 表示加入的视频通话，同一时间只能加入一个视频通话。
 */
@interface WDGVideoConversation : NSObject

/**
 表示当前视频通话的编号。
 */
@property (nonatomic, strong, readonly) NSString *ID;

/**
 `WDGVideoConnectionStatus` 类型，表示视频通话的状态。
 */
@property (nonatomic, assign, readonly) WDGVideoConnectionStatus status;

/**
 `WDGVideoLocalParticipant` 类型，表示当前视频通话所使用的本地视频、音频流。
 */
@property (nonatomic, strong, readonly) WDGVideoLocalParticipant *localParticipant;

/**
 `WDGVideoParticipant` 对象，视频通话的对方。
 */
@property (nonatomic, strong, readonly) WDGVideoParticipant *participant;

/**
 符合 `WDGVideoConversationDelegate` 协议的代理。
 */
@property (nonatomic, weak, nullable) id<WDGVideoConversationDelegate> delegate;


/**
 符合 `WDGVideoConversationStatsDelegate` 协议的代理。用于获取统计数据。
 */
@property (nonatomic, weak, nullable) id<WDGVideoConversationStatsDelegate> statsDelegate;

/**
 断开当前视频通话的连接。
 */
- (void)disconnect;

/**
 通过调用该方法录制视频。
 @param filePath 视频文件保存路径。
 */
- (BOOL)startVideoRecording:(NSString *)filePath;
/**
 通过调用该方法停止录制视频。action:这里不是暂停
 */
- (void)stopVideoRecording;
@end

/**
 `WDGVideoConversation` 的代理方法。
 */
@protocol WDGVideoConversationDelegate <NSObject>
@optional

/**
 `WDGVideoConversation` 通过调用该方法通知代理当前视频通话已建立连接。

 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 */
- (void)conversationDidConnected:(WDGVideoConversation *)conversation;

/**
 `WDGVideoConversation` 通过调用该方法通知代理当前视频通话未能建立连接。

 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param error 错误信息，描述未能建立连接的原因。
 */
- (void)conversation:(WDGVideoConversation *)conversation didFailedToConnectWithError:(NSError *)error;

/**
 `WDGVideoConversation` 通过调用该方法通知代理当前视频通话已断开连接。

 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param error 错误信息，描述连接断开的原因。本地主动断开连接时为 nil。
 */
- (void)conversation:(WDGVideoConversation *)conversation didDisconnectWithError:(NSError *_Nullable)error;

/**
 `WDGVideoConversation` 通过调用该方法通知代理当前视频通话有新的参与者加入。

 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param participant  代表新的参与者的 `WDGVideoParticipant` 实例。
 */
- (void)conversation:(WDGVideoConversation *)conversation didConnectParticipant:(WDGVideoParticipant *)participant;

/**
 `WDGVideoConversation` 通过调用该方法通知代理当前视频通话某个参与者断开了连接。

 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param participant  代表已断开连接的参与者的 `WDGVideoParticipant` 实例。
 */
- (void)conversation:(WDGVideoConversation *)conversation didDisconnectParticipant:(WDGVideoParticipant *)participant;

@end

/**
 `WDGVideoConversation` 的统计代理方法。
 */
@protocol WDGVideoConversationStatsDelegate <NSObject>
@optional

/**
 `WDGVideoConversation` 通过调用该方法通知代理处理当前视频通话中本地视频流的统计信息。

 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param report 包含统计信息的 `WDGVideoLocalStreamStatsReport` 实例。
 */
- (void)conversation:(WDGVideoConversation *)conversation didUpdateLocalStreamStatsReport:(WDGVideoLocalStreamStatsReport *)report;

/**
 `WDGVideoConversation` 通过调用该方法通知代理处理当前视频通话中远程视频流的统计信息。

 @param conversation 调用该方法的 `WDGVideoConversation` 实例。
 @param report 包含统计信息的 `WDGVideoRemoteStreamStatsReport` 实例。
 */
- (void)conversation:(WDGVideoConversation *)conversation didUpdateRemoteStreamStatsReport:(WDGVideoRemoteStreamStatsReport *)report;

@end

NS_ASSUME_NONNULL_END
