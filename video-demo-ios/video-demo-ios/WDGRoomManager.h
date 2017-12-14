//
//  WDGRoomManager.h
//  video-demo-ios
//
//  Created by wilddog on 2017/12/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGRoomManager : NSObject
-(instancetype)initWithRoomId:(NSString *)roomId complete:(void (^)(NSTimeInterval))complete;
-(void)closeOperation;
@end
