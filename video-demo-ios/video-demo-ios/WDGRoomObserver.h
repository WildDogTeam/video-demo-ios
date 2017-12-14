//
//  WDGRoomObserver.h
//  video-demo-ios
//
//  Created by wilddog on 2017/12/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGRoomObserver : NSObject
- (void)handleObserver;
- (void)roomOpen:(NSString *)roomId;
- (void)roomClose:(NSString *)roomId;
-(void)clearObserver;
@end
