//
//  WDGSimpleConnection.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGSimpleConnection : NSObject
+(void)connectionWithUrlString:(NSString *)urlString completion:(void(^)(NSDictionary *))completion;
+(void)connectionWithPostUrlString:(NSString *)urlString requestHeader:(NSDictionary *)header body:(NSDictionary *)body completion:(void(^)(NSDictionary *))completion;
@end
