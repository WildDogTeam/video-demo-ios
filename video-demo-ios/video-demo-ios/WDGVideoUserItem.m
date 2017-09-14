//
//  WDGVideoItem.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoUserItem.h"
#import "WilddogSDKManager.h"
NSString *const WDGVideoUserItemNickNameKey =@"nickname";
NSString *const WDGVideoUserItemFaceUrlKey =@"faceurl";
NSString *const WDGVideoUserItemDeviceIdKey =@"deviceid";

@implementation WDGVideoUserItem
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

+(void)requestForUid:(NSString *)uid complete:(void (^)(WDGVideoUserItem *))complete
{
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        WDGVideoUserItem *item = [WDGVideoUserItem new];
        item.uid =uid;
        if([(NSDictionary *)snapshot.value objectForKey:uid]){
            id userinfo =[(NSDictionary *)snapshot.value objectForKey:uid];
            if([userinfo isKindOfClass:[NSDictionary class]]){
                item.nickname = [userinfo objectForKey:WDGVideoUserItemNickNameKey];
                item.faceUrl = [userinfo objectForKey:WDGVideoUserItemFaceUrlKey];
            }
        }
        complete(item);
    }];

}

@end
