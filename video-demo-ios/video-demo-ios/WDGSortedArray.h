//
//  WDGSortedArray.h
//  TestSound
//
//  Created by han wp on 2017/8/17.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDGVideoItem.h"

@interface WDGSortedArray : NSObject
+(nullable NSIndexPath *)addObject:(WDGVideoItem *_Nonnull)nickName;
+(nullable NSIndexPath *)removeObject:(WDGVideoItem *_Nonnull)nickName;
+(nullable NSArray <NSArray<WDGVideoItem *> *> *)sortedArray;
+(nullable NSArray *)indexes;
+(void)removeAllObject;
@end
