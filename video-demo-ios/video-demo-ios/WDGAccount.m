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
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.iconUrl forKey:@"iconUrl"];
}

-(NSString *)token
{
    return _token?:@"";
}

-(NSString *)nickName
{
    return _nickName?:_userID;
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
    _currentAccount =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:WDGAccountInfo]];
    if(!_currentAccount){
        _currentAccount = [WDGAccount new];
    }
    return _currentAccount;
}

@end
