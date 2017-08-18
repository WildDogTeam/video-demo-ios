//
//  WDGSortedArray.h
//  TestSound
//
//  Created by han wp on 2017/8/17.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGSortObject : NSObject
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *nickname;
@end

@interface WDGSortedArray : NSObject
+(nullable NSIndexPath *)addObject:(WDGSortObject *_Nonnull)nickName;
+(nullable NSIndexPath *)removeObject:(WDGSortObject *_Nonnull)nickName;
+(nullable NSArray <NSArray<WDGSortObject *> *> *)sortedArray;
+(nullable NSArray *)indexes;
+(void)removeAllObject;
@end
