//
//  WDGPhoneNumCheckValid.h
//  video-demo-ios
//
//  Created by han wp on 2017/9/28.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDGPhoneNumCheckValid : NSObject
+(void)phoneNumber:(NSString *)phoneNum isValid:(void(^)(BOOL isValid,NSString *reason))isValid;
@end
