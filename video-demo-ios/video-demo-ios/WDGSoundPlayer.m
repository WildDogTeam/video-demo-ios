//
//  WDGSoundPlayer.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/14.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGSoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation WDGSoundPlayer
static SystemSoundID soundID = 0;
+(void)playSound:(SoundType)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:type==SoundTypeCaller?@"ring":@"videoRing" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        if(soundID){
            [self playSound:type];
        }
    });
}

+(void)stop
{
    AudioServicesDisposeSystemSoundID(soundID);
    soundID = 0;
}
@end
