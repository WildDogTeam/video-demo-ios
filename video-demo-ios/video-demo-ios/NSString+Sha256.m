//
//  NSString+Sha256.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/31.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "NSString+Sha256.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Sha256)
-(NSString *)sha256
{
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}
@end
