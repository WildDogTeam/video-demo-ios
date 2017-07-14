//
//  WDGVideoLocalParticipant.h
//  WilddogVideo
//
//  Created by Zheng Li on 11/4/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGVideoLocalStream;

NS_ASSUME_NONNULL_BEGIN

/**
 代表视频通话和会议的本地参与者。
 */
@interface WDGVideoLocalParticipant : NSObject

/**
 本地参与者的 Wilddog ID。
 */
@property (nonatomic, strong, readonly) NSString *ID;

/**
 本地参与者发布的媒体流。
 */
@property (nonatomic, strong, readonly) WDGVideoLocalStream *stream;

@end

NS_ASSUME_NONNULL_END
