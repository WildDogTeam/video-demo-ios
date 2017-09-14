//
//  WDGVideoItem.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXTERN NSString * const WDGVideoUserItemNickNameKey;
FOUNDATION_EXTERN NSString * const WDGVideoUserItemFaceUrlKey;
FOUNDATION_EXTERN NSString * const WDGVideoUserItemDeviceIdKey;

@interface WDGVideoUserItem : NSObject<NSCoding>
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *faceUrl;
+(void)requestForUid:(NSString *)uid complete:(void (^)(WDGVideoUserItem *item))complete;
@end
