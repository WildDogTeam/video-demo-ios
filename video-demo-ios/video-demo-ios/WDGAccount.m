//
//  WDGAccount.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGAccount.h"
#define WDGAccountInfo @"com.wilddog.accountInfo"
@implementation WDGAccount
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userID"];
}
@end

@implementation WDGAccountManager
static WDGAccount *_currentAccount = nil;
+(void)setCurrentAccount:(WDGAccount *)account
{
    _currentAccount = account;
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:account] forKey:WDGAccountInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(WDGAccount *)currentAccount
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentAccount =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:WDGAccountInfo]];
    });
    return _currentAccount;
}

@end
