//
//  WDGSoundPlayer.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/14.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,SoundType){
    SoundTypeCaller,
    SoundTypeCallee
};
@interface WDGSoundPlayer : NSObject
+(void)playSound:(SoundType)type;
+(void)stop;
@end
