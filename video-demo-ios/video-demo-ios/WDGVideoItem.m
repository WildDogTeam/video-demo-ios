//
//  WDGVideoItem.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoItem.h"
#import "WilddogSDKManager.h"
NSString *const WDGVideoItemNickNameKey =@"nickname";
NSString *const WDGVideoItemFaceUrlKey =@"faceurl";

@implementation WDGVideoItem
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.uid = [coder decodeObjectForKey:@"uid"];
        self.nickname = [coder decodeObjectForKey:@"nickname"];
        self.faceUrl = [coder decodeObjectForKey:@"faceUrl"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.faceUrl forKey:@"faceUrl"];
}

-(NSString *)description
{
    return self.nickname?:self.uid;
}

+(void)requestForUid:(NSString *)uid complete:(void (^)(WDGVideoItem *))complete
{
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        WDGVideoItem *item = [WDGVideoItem new];
        item.uid =uid;
        if([(NSDictionary *)snapshot.value objectForKey:uid]){
            NSDictionary *userinfo =[(NSDictionary *)snapshot.value objectForKey:uid];
            if(userinfo){
                item.nickname = [userinfo objectForKey:WDGVideoItemNickNameKey];
                item.faceUrl = [userinfo objectForKey:WDGVideoItemFaceUrlKey];
            }
        }
        complete(item);
    }];

}

@end
