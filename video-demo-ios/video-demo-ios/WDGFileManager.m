//
//  WDGFileManager.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGFileManager.h"

@implementation WDGFileObject

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.recordTime = ((NSNumber *)[aDecoder decodeObjectForKey:@"recordTime"]).unsignedIntegerValue;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:@(self.recordTime) forKey:@"recordTime"];
}

@end

#define WDGRecordSaveListFile @"com.wilddog.record.saveInfolist"

@interface WDGFileManager()
@property (nonatomic,strong) NSMutableDictionary *recordList;
@end

@implementation WDGFileManager
+(instancetype)sharedManager
{
    static WDGFileManager *_fileManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fileManager = [[self alloc] init];
    });
    return _fileManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dict =[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:WDGRecordSaveListFile]];
        self.recordList = dict?[NSMutableDictionary dictionaryWithDictionary:dict]:[NSMutableDictionary dictionary];
    }
    return self;
}

-(BOOL)saveFile:(WDGFileObject *)fileObj withName:(NSString *)name overWrite:(BOOL)overWrite
{
    if(!overWrite){
        if([self.recordList objectForKey:name]){
            NSLog(@"文件名重名。。。。");
            return NO;
        }
    }
    [self.recordList setObject:fileObj forKey:name];
    [self writeToFile];
    return YES;
}

-(WDGFileObject *)fileObjectForName:(NSString *)name
{
    return [self.recordList objectForKey:name];
}

-(NSArray *)saveFileNames
{
    return self.recordList.allKeys;
}

-(void)deleteFileWithName:(NSString *)name
{
    WDGFileObject *fileObj = [self.recordList objectForKey:name];
    if(fileObj){
        [self.recordList removeObjectForKey:name];
        [self deleteFileWithPath:fileObj.filePath];
    }
}

-(void)deleteFileWithObject:(WDGFileObject *)fileObj
{
    [self.recordList removeObjectForKey:fileObj.fileName];
    [self deleteFileWithPath:fileObj.filePath];
}

-(void)deleteFileWithPath:(NSString *)filePath
{
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [self writeToFile];
}

-(void)writeToFile
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.recordList] forKey:WDGRecordSaveListFile];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
