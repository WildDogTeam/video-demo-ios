//
//  WDGConversationsHistory.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDGVideoUserItem.h"
@interface WDGConversationItem:WDGVideoUserItem

@property (nonatomic,assign) long conversationTime;
@property (nonatomic,assign) long long finishTime;
@end
@interface WDGConversationsHistory : NSObject
+(void)addHistoryItem:(WDGConversationItem *)item;
+(NSUInteger)count;
+(WDGConversationItem *)itemAtIndex:(NSUInteger)index;
@end
