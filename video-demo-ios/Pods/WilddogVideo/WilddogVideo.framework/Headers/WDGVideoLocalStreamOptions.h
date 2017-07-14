//
//  WDGVideoLocalStreamOptions.h
//  WilddogVideo
//
//  Created by Zheng Li on 11/7/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 视频质量选项。

 - WDGVideoConstraints360p: 视频尺寸 352x288
 - WDGVideoConstraints480p: 视频尺寸 640x480
 - WDGVideoConstraints720p: 视频尺寸 1280x720
 - WDGVideoConstraints1080p: 暂不支持，设置此选项视频尺寸为 1280x720
 */
typedef NS_ENUM(NSUInteger, WDGVideoConstraints) {
    WDGVideoConstraints360p,
    WDGVideoConstraints480p,
    WDGVideoConstraints720p,
    WDGVideoConstraints1080p, 
};

NS_ASSUME_NONNULL_BEGIN

/**
 本地视频流配置。
 */
@interface WDGVideoLocalStreamOptions : NSObject

/**
 本地视频流的音频开关。默认为开。
 */
@property (nonatomic, assign) BOOL audioOn;

/**
 视频质量选项。默认为 `WDGVideoConstraints480p`。
 */
@property (nonatomic, assign) WDGVideoConstraints videoOption;

/**
 使用默认配置初始化。默认配置为音频开启，视频质量使用 `WDGVideoConstraints480p` 选项。

 @return `WDGVideoLocalStreamOptions`实例。
 */
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
