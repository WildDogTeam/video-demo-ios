//
//  WDGConversationsHistory.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGConversationsHistory.h"
#define WDGConversationsHistoryKey @"com.wilddog.conversationsHistoryKey"
@implementation WDGConversationItem
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:(NSCoder *)aDecoder]){
        self.conversationTime = [[aDecoder decodeObjectForKey:@"conversationTime"] longValue];
        self.finishTime =[[aDecoder decodeObjectForKey:@"finishTime"] longValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:@(self.conversationTime) forKey:@"conversationTime"];
    [aCoder encodeObject:@(self.finishTime) forKey:@"finishTime"];
}
@end
@implementation WDGConversationsHistory
static NSArray *conversationsHistory = nil;
+(void)addHistoryItem:(WDGConversationItem *)item
{
    NSArray *history =[self getConversationsHistory];
    NSMutableArray *uids = [NSMutableArray arrayWithArray:history[0]];
    [uids removeObject:item.uid];
    [uids insertObject:item.uid atIndex:0];
    NSMutableDictionary *items = [NSMutableDictionary dictionaryWithDictionary:history[1]];
    [items setObject:item forKey:item.uid];
    conversationsHistory = @[uids,items];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:conversationsHistory] forKey:WDGConversationsHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray *)getConversationsHistory
{
    if(!conversationsHistory){
        NSArray *history = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:WDGConversationsHistoryKey]];
        conversationsHistory =history?:@[@[],@{}];
    }
    return conversationsHistory;
}

+(NSUInteger)count
{
    return [[self getConversationsHistory][0] count];
}

+(WDGConversationItem *)itemAtIndex:(NSUInteger)index
{
    if(index>self.count){
#if DEBUG
        NSAssert(0, @"数组越界");
#endif
        return nil;
    }
    NSArray *history = [self getConversationsHistory];
    NSDictionary *items = history[1];
    NSArray *uids = history[0];
    return [items objectForKey:[uids objectAtIndex:index]];
}
@end
