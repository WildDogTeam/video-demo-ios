//
//  WDGFileManager.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGFileObject : NSObject<NSCoding>
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,assign) NSUInteger recordTime;
@end

@interface WDGFileManager : NSObject
+(instancetype)sharedManager;
-(BOOL)saveFile:(WDGFileObject *)fileObj withName:(NSString *)name overWrite:(BOOL)overWrite;
-(WDGFileObject *)fileObjectForName:(NSString *)name;
-(NSArray *)saveFileNames;
-(void)deleteFileWithName:(NSString *)name;
-(void)deleteFileWithObject:(WDGFileObject *)fileObj;
@end
