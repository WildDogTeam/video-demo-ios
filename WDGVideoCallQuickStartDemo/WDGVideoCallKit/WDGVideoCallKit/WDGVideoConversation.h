//
//  WDGVideoConversation.h
//  WDGVideoKit
//
//  Created by han wp on 2017/10/12.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGVideoConversation;
@protocol WDGVideoConversationStatusDelegate<NSObject>
-(void)videoStatusDidChanged:(WDGVideoConversation *)videoConversation;
@end

typedef NS_ENUM(NSUInteger, WDGVideoConversationState){
    WDGVideoConversationStateNormal    = 1  , //初始化状态
    WDGVideoConversationStatePending        , //拨打电话到对方应答(接听,拒接,超时)之间的状态
    WDGVideoConversationStateIncoming       , //收到一个通话到自己做出应答(接听,拒接,超时)之间的状态
    WDGVideoConversationStateConnecting     , //通话应答到通话连接之间的状态 状态时间很短
    WDGVideoConversationStateOnCalling      , //通话中
    WDGVideoConversationStateFinishCalling  , //通话结束 详细信息见WDGVideoFinishReason
};

typedef NS_ENUM(NSUInteger, WDGVideoFinishReason){
    WDGVideoFinishReasonNormal,                     //初始化状态 WDGVideoCallStatePending,WDGVideoCallStateIncoming下重置
    WDGVideoFinishReasonBusy,               // 对方正在通话中
    WDGVideoFinishReasonCancel,             // 拨打电话并在对方未做应答前取消通话
    WDGVideoFinishReasonCancelByOppositeSide,   //对方取消通话
    WDGVideoFinishReasonReject,             //拒接
    WDGVideoFinishReasonRejectedByOppositeSide,     //对方拒接
    WDGVideoFinishReasonHungupByOppositeSide,       //通话中对方挂断通话
    WDGVideoFinishReasonHungupByMySelf,             //通话中自己挂断通话
    WDGVideoFinishReasonNoAnswerByOppositeSide,         //拨打电话对方未在规定时间内应答操作
    WDGVideoFinishReasonOutOfTimeForAnswer,         //在超时时间内未接听通话
    WDGVideoFinishReasonOutOfTimeForReConnection,   //通话中网络等原因造成通话断开并在超时时间内没有重连成功
    WDGVideoFinishReasonError, //sdk 视频连接error
    
    
    /*
     *  需要用户自行添加 快速集成demo没有黑名单系统
     **/
    WDGVideoFinishReasonInBlack,                    //黑名单 不得向对方通话
    
};

@interface WDGVideoConversationConfig : NSObject
@property (nonatomic,assign) WDGVideoConversationState videoConversationState;
@property (nonatomic,assign,readonly) NSTimeInterval currentTime;
@property (nonatomic,assign) WDGVideoFinishReason videoFinishReason;
@property (nonatomic,copy) NSString *oppositeUid;
@end

@interface WDGVideoConversation : NSObject

@property (nonatomic,strong) WDGVideoConversationConfig *config;
@property (nonatomic,assign) BOOL shouldLoudspeaker;
@end
