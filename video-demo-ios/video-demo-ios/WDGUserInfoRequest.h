//
//  WDGUserInfoRequest.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGUserInfoRequest : NSObject
+(void)requestForUserInfoWithCode:(NSString *)code complete:(void(^)())complete;
@end
