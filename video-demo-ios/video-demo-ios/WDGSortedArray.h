//
//  WDGSortedArray.h
//  TestSound
//
//  Created by han wp on 2017/8/17.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDGVideoUserItem.h"

@interface WDGSortedArray : NSObject
+(nullable NSIndexPath *)addObject:(WDGVideoUserItem *_Nonnull)nickName;
+(nullable NSIndexPath *)removeObject:(WDGVideoUserItem *_Nonnull)nickName;
+(nullable NSArray <NSArray<WDGVideoUserItem *> *> *)sortedArray;
+(nullable NSArray *)indexes;
+(void)removeAllObject;
@end
