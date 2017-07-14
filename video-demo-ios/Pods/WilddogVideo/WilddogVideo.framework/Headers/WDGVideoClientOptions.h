//
//  WDGVideoClientOptions.h
//  WilddogVideo
//
//  Created by Zheng Li on 11/4/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 初始化 `WDGVideoClient` 对象时使用的配置选项。
 */
@interface WDGVideoClientOptions : NSObject

/**
 回调将在该队列中调用。默认为 main queue。
 */
@property (nonatomic, strong) dispatch_queue_t delegateQueue;

@end

NS_ASSUME_NONNULL_END
