//
//  WDGVideoItem.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXTERN NSString * const WDGVideoItemNickNameKey;
FOUNDATION_EXTERN NSString * const WDGVideoItemFaceUrlKey;
@interface WDGVideoItem : NSObject<NSCoding>
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *faceUrl;
+(void)requestForUid:(NSString *)uid complete:(void (^)(WDGVideoItem *item))complete;
@end
