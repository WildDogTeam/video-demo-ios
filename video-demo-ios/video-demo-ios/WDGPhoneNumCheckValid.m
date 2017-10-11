//
//  WDGPhoneNumCheckValid.m
//  video-demo-ios
//
//  Created by han wp on 2017/9/28.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGPhoneNumCheckValid.h"

@implementation WDGPhoneNumCheckValid
+(void)phoneNumber:(NSString *)phoneNum isValid:(void(^)(BOOL isValid,NSString *reason))isValid
{
    if (!phoneNum || phoneNum.length < 11)
    {
        isValid(NO,@"手机号长度只能是11位");
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        if ([pred1 evaluateWithObject:phoneNum] || [pred2 evaluateWithObject:phoneNum] || [pred3 evaluateWithObject:phoneNum]) {
            isValid(YES,@"");
        }else{
            isValid(NO,@"请输入正确的电话号码");
        }
    }
}

@end
