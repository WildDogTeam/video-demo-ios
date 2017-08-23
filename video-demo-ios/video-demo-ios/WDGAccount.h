//
//  WDGAccount.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGAccount : NSObject<NSCoding>
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *iconUrl;
@end

@interface WDGAccountManager : NSObject
+(WDGAccount *)currentAccount;
+(void)setCurrentAccount:(WDGAccount *)account;
@end
