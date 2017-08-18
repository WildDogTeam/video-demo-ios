//
//  WDGSortedArray.m
//  TestSound
//
//  Created by han wp on 2017/8/17.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGSortedArray.h"

@implementation NSArray (WDGSortArray)

-(NSUInteger)indexOfObjectEqualToString:(NSString *)string
{
    __block NSUInteger uint =NSNotFound;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:string]){
            uint = idx;
        }
    }];
    return uint;
}

@end

@implementation WDGSortObject
-(NSString *)description
{
    return self.nickname;
}
@end


static NSMutableArray<NSMutableArray<WDGSortObject *> *> *_sortedArray;
static NSMutableDictionary *_indexes;
static NSMutableArray<NSMutableArray *> *_nameSortedArray;
static dispatch_queue_t _sortqueue;
static void *sortQueueKey;
typedef NSIndexPath *(^SortBlock)();
NSIndexPath* runSyncSortedArrayInSortQueue(SortBlock block)
{
    __block NSIndexPath *indexpath = [NSIndexPath new];
    if(dispatch_get_specific(sortQueueKey)){
        indexpath =block();
    }else{
        dispatch_sync(_sortqueue, ^{
            indexpath =block();
        });
    }
    return indexpath;
}
@implementation WDGSortedArray
+(NSIndexPath *)addObject:(WDGSortObject *)nickName
{
    [self initSortArray];
    return runSyncSortedArrayInSortQueue(^{
        return [self _addObject:nickName];
    });
}

+(NSIndexPath *)_addObject:(WDGSortObject *)obj
{
    return [self sortAddObject:obj];
}

+(NSIndexPath *)removeObject:(WDGSortObject *)obj
{
    [self initSortArray];
    return runSyncSortedArrayInSortQueue(^{
        return [self _removeObject:obj];
    });
}

+(NSIndexPath *)_removeObject:(WDGSortObject *)obj
{
    return [self sortRemoveObject:obj];
}

+(NSArray<NSArray<WDGSortObject *> *> *)sortedArray
{
    return _sortedArray;
}

+(void)initSortArray
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self init];
    });
}

+(void)init
{
    
    if(!_sortedArray){
        _sortedArray = [NSMutableArray array];
        _sortqueue = dispatch_queue_create("com.wilddog.conversation.sortQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(_sortqueue, sortQueueKey, &sortQueueKey,NULL);
        _nameSortedArray = [NSMutableArray array];
        _indexes = [NSMutableDictionary dictionary];
    }

}

+(NSArray *)indexes
{
    return  [self maopaoSortedArray:[_indexes allKeys]];
}

+(NSIndexPath *)sortAddObject:(WDGSortObject *)obj
{
    NSInteger section;
    NSInteger row;
    NSString *pinyin =[self test:obj.nickname];
    char firstChar = [pinyin characterAtIndex:0];
    NSString *firstString =[pinyin substringToIndex:1];
    if(firstChar <'A' || firstChar >'Z'){
        firstString =@"#";
    }
    [_indexes setObject:@"" forKey:firstString];
    section = [[self indexes] indexOfObjectEqualToString:firstString];
    if(_indexes.allKeys.count == _nameSortedArray.count && section!=NSNotFound){
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_nameSortedArray[section]];
        for (NSInteger i=arr.count-1;i>=0;i--) {
            NSString *str =arr[i];
            if([pinyin compare:str]<0){
                if(i==0)
                    [arr insertObject:pinyin atIndex:i];
                continue;
            }else{
                [arr insertObject:pinyin atIndex:i+1];
                break;
            }
        }
        row = [arr indexOfObjectEqualToString:pinyin];
        [_nameSortedArray[section] insertObject:pinyin atIndex:row];
        [_sortedArray[section] insertObject:obj atIndex:row];
    }else{
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:obj];
        [_sortedArray insertObject:arr atIndex:section];
        NSMutableArray *pinyinArr = [NSMutableArray array];
        [pinyinArr addObject:pinyin];
        [_nameSortedArray insertObject:pinyinArr atIndex:section];
        row = 0;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

+(NSIndexPath *)sortRemoveObject:(WDGSortObject *)obj
{
    NSInteger section;
    NSInteger row;
    NSString *pinyin =[self test:obj.nickname];
    char firstChar = [pinyin characterAtIndex:0];
    NSString *firstString =[pinyin substringToIndex:1];
    if(firstChar <'A' || firstChar >'Z'){
        firstString =@"#";
    }
    section = [[self indexes] indexOfObjectEqualToString:firstString];
    if(section==NSNotFound){
        return nil;
    }else{
        row = [_nameSortedArray[section] indexOfObjectEqualToString:pinyin];
        if(row == NSNotFound)return nil;
        if(_sortedArray[section].count ==1){
            [_sortedArray removeObjectAtIndex:section];
            [_nameSortedArray removeObjectAtIndex:section];
            [_indexes removeObjectForKey:firstString];
        }else{
            [_sortedArray[section] removeObjectAtIndex:row];
            [_nameSortedArray[section] removeObjectAtIndex:row];
        }
    }
    return [NSIndexPath indexPathForRow:row inSection:section];
}

+(NSString *)test:(NSString *)hehe
{
    NSMutableString *ms = [[NSMutableString alloc]initWithString:hehe];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformMandarinLatin, NO)) {
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO)) {
        
        NSString *bigStr = [ms uppercaseString];
        return [bigStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return nil;
}

+(NSArray *)maopaoSortedArray:(NSArray *)sortedArr
{
    NSMutableArray *temp = [sortedArr mutableCopy];
    for (int i=0; i<temp.count; i++) {
        for (int j=i+1; j<temp.count; j++) {
            NSString *str1 =temp[i];
            NSString *str2 =temp[j];
            if([str1 isEqualToString:@"#"]){
                [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                continue;
            }
            if([str1 compare:str2]>0 &&![str2 isEqualToString:@"#"]){
                [temp exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return temp;
}

+(void)removeAllObject
{
    _indexes = nil;
    _sortqueue = nil;
    _sortedArray = nil;
    sortQueueKey = nil;
    [self init];
}
@end
