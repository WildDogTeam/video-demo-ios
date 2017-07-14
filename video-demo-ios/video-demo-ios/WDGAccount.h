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
@end

@interface WDGAccountManager : NSObject
+(WDGAccount *)currentAccount;
+(void)setCurrentAccount:(WDGAccount *)account;
@end
