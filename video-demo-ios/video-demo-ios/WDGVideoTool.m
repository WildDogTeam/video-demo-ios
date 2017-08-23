//
//  WDGVideoTool.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoTool.h"

@implementation WDGVideoTool
static NSDateFormatter *_dateFormatter;

+(void)dateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
}

+(NSString *)recordCurrentTime
{
    [self dateFormatter];
    NSDate *date = [NSDate date];
    long long dTime = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];
    _dateFormatter.dateFormat = @"yyyyMMdd";
    NSString *dateStr = [_dateFormatter stringFromDate:[NSDate date]];
    return [dateStr stringByAppendingString:[NSString stringWithFormat:@"-%@",curTime]];
}

+(NSString *)currentRecordFilePath
{
    return [[self currentRecordFileDirectory] stringByAppendingPathComponent:[self recordCurrentTime]];
}

+(NSString *)currentRecordFileDirectory
{
    NSString *libraryDirectory =[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    return [libraryDirectory stringByAppendingPathComponent:@"WiddogRecordFiles"];
}

#define oneMinute 60
#define anHour 60*60

+(NSString *)conversationDetailTimeForTimeInterval:(NSTimeInterval)time
{
    [self dateFormatter];
    NSDate *nowDate =[NSDate date];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    if(now-time<=oneMinute){
        return @"刚刚";
    }
    if(now - time >oneMinute && now - time <anHour){
        NSInteger minute = (now - time)/oneMinute;
        return [NSString stringWithFormat:@"%ld分钟前",minute];
    }
    _dateFormatter.dateFormat = @"MM/dd<->HH:mm";
    if(now - time >= anHour){
        NSString *timeFormatStr = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        NSString *nowFormatStr = [_dateFormatter stringFromDate:nowDate];
        NSArray *timeArr = [timeFormatStr componentsSeparatedByString:@"<->"];
        NSArray *nowArr = [nowFormatStr componentsSeparatedByString:@"<->"];
        if([timeArr[0] isEqualToString:nowArr[0]]){
            return timeArr[1];
        }else{
            return timeArr[0];
        }
    }
    return nil;
}


@end

