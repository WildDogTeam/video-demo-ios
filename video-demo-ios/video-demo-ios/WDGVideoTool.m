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

+(NSString *)recordCurrentTime
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.dateFormat = @"yyyyMMdd";
    });
    NSDate *date = [NSDate date];
    long long dTime = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];
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


@end

