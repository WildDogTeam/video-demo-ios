//
//  WDGSignalPush.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/25.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGSignalPush : NSObject
+(void)prepare;
+(void)pushVideoCallWithUid:(NSString *)uid;
@end
