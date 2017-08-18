//
//  WDGCamera360Option.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/13.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGCamera360Option.h"
#import "PGSkinPrettifyEngine.h"

#define DEMOKEY @"lqm28F5WuJhPC/ybYeLEZWvJvKnBZxz7iV/4cchHDi395R7DsL7UhEA9YPg9Vn93guT1dgl677r7Xx87nWhqtMe4NnB7Vwr4O7V0ELi37eviUsFH1KHCoMjq6hDOFSMdkf8M4VvILJTTnEpwlcN7MSSu7OSxjPdJxwD0qzjRgGz6zWRrue5uxhyzLLqQCxMZi9igFOc2i5FazlILF62AfJrMMH1kYJLY08kD4ntyC5RmVBWsC2oM8x7DTByEdVbSaqrgpfB5sCMYDYWFwAsj1nGs9TK/o72FCuYL23oEiv3RoJyOnmzoo2bCENLun1chDT6qnmwnyFhsh45OVPPF2mT0nytg7nbS8flaBWC4K4x8Rq38gZ0aDlY8pu6O39LNi55NWHRplacS8PYa0IbUJ5OWsT2bZ+q2LCBte1G09D/DgILAWWY9twEUU6XA4q5B1xDZICEXLG8hwoNQ7Yg0qEuha5lReMGHSqe+1nKUaEWg5LleWTD5uQKKzwVguldt7dJW+Q7OyhNhn7+RWYULI2lxsk/DbBwp4g74AUZmih6o0dTnefvytHGSRYvXkD4LO9ygOiNZet4DOMoT0/8Viblk1um1n7CcuFgrrfaclxsLcyt6rX3K/AyZBDEycrY49X+WtMZx+VkH07iGBysuDct4YTg1PaQQI9EpJGScweib1f3ZliFcxsq0zfoaJ9vcq1Ls23UUSmvOVDP2Y6rgQmNZ2hGIQ1z2wDNcc6+85TleWahLAQPgMsxIKuY9bi7Pc2//ranrHChNTn0JZo6mhyCcFEZZEApYf9DqAqVRC+XAFqmpwRyLbtWTCqXvE19SMkpPRmhk85SA9LfLdsBErQbNUgC7jOXU5s7jtJ03siu+zPmbMeD27Y4a9BqieNEpdGU+hDShkfawopK1Q2SBNhGNDROXSrrvl0/dci61ubAet0GqyYTLgVawaIjVQ4x/ogqvkL14dTe5suxEHXhWSqxwhx6AKiLqYZQIulHWXrwUr9nB8ui3Vg5iC4Mbmyp/60b5S/HGrnBoaqBemGMRGBaVkiFo5VVril4GEXr1Gy6B08bfbmT2cbb6Kwh/yLIguJMQinO0OU/fy9pia1dTMdfmAq/S71lLsQbwwd5p5sFCTLvDRNrDQJwKI+g9fHjEhwNQHXWQSPB8jDNWvxlcmch2eNzKzYDhzZvF31IuotZ1AZALLkmTNLs53ykje0m20rezOzZ+femlwf//P29HyDMTLfV7KEjn0K29MfZl3/39qPzK7Y/jthAWcu8I7lxjVgkn2oxmc6wOKp0OLAaHLHFzn3PadLAl9IhW7fcdYwoRQRnf4/zESd/NN5UN+g8ZqcJnFJU11TPG5mUQ8sSdeNF8BMZfwSwLyN+khNIal06qcH8KKnX/pzua7/HiDUbfNFwsKS4YyEwKSeQKrQ78A7uDXwAvVxfxy1NicTXo1hYwUu+60OCMC9CFRTfhBk2aVfx7vKdIv9mne09rmZm5ahlSk7HHb1lvy8p47c29b9THniwXhhXOnR6ALEZZc6ma74JWVcwJbyY8KHaV3DAYoCUwRt6d5sovJEZEehyOWhglJm8hiyNeM2wkklAxPD6LC33hpDw8enBpZeruN4wgt2E18d7bVSwpd7CVtSJpnvkNXkqyKxu/5YovkB4kxEcaEsQCqGOmNAE4w8Il/7E7Xhp/2mEisMfxZSqTQLHNU+J3bIYGwTo8oNq7FxJY70U/X6dWb+8abTvwmjo2jByd"

@interface WDGCamera360Option () {
    BOOL _bIsFirstFrame;
}

// camera 360
@property (nonatomic, strong) PGSkinPrettifyEngine *pPGSkinPrettifyEngine;

@end

@implementation WDGCamera360Option

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCamera360];
    }
    return self;
}

- (CVPixelBufferRef)proccessPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    double start = [[NSDate date] timeIntervalSince1970];
    
    if (!_pPGSkinPrettifyEngine) {
        return pixelBuffer;
    }
    _bIsFirstFrame = YES;
    CGSize size = CVImageBufferGetDisplaySize(pixelBuffer);
    PGOrientation orientation = PGOrientationNormal;
    
    // 在第一帧视频到来时，初始化美肤引擎，指定需要的输出大小和输出委托
    if (_bIsFirstFrame)
    {
        PGOrientation orientForAdjustInput = PGOrientationNormal;
        CGSize sizeForAdjustInput = CGSizeMake(size.width, size.height);
        
        [_pPGSkinPrettifyEngine SetSizeForAdjustInput:sizeForAdjustInput];
        [_pPGSkinPrettifyEngine SetOrientForAdjustInput:orientForAdjustInput];
        [_pPGSkinPrettifyEngine SetOutputFormat:PGPixelFormatYUV420];
        //        [_pPGSkinPrettifyEngine SetSkinPrettifyResultDelegate:self];
        [_pPGSkinPrettifyEngine SetSkinSoftenStrength:80];
        [_pPGSkinPrettifyEngine SetSkinColor:0.6 Whitening:0.5 Redden:0.3];
        
        _bIsFirstFrame = NO;
    }
    
    //  对当前帧进行美肤
    [_pPGSkinPrettifyEngine SetOutputOrientation:orientation];
    
    [_pPGSkinPrettifyEngine SetInputFrameByCVImage:pixelBuffer];
    [_pPGSkinPrettifyEngine SetSkinColor:0.6 Whitening:0.5 Redden:0.3];
    [_pPGSkinPrettifyEngine RunEngine];
    //        [_pPGSkinPrettifyEngine PGOglViewPresent];
    
    CVPixelBufferRef ansBuffer = NULL ;
    [_pPGSkinPrettifyEngine GetSkinPrettifyResult:&ansBuffer];
    OSType type = CVPixelBufferGetPixelFormatType(ansBuffer);
    if (type != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        NSLog(@"error pixel type");
        return pixelBuffer;
    }
//    double end = [[NSDate date] timeIntervalSince1970];
//    double duration = end - start;
//    NSLog(@"duration %f",duration);
    
    return ansBuffer;
}

- (void)setupCamera360 {
    _pPGSkinPrettifyEngine = [[PGSkinPrettifyEngine alloc] init];
    
    [_pPGSkinPrettifyEngine InitEngineWithKey:DEMOKEY];
    
    [self.pPGSkinPrettifyEngine SetSkinSoftenAlgorithm:PGSoftenAlgorithmContrast];
    
    /*--------------------增加滤镜----------------------*/
    
    //    [_pPGSkinPrettifyEngine SetColorFilterStrength:100];
    //    [_pPGSkinPrettifyEngine SetColorFilterByName:@"Deep"];
    
    /*---------------------------------增加贴纸---------------------------------*/
    
    //    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //    NSString *stickerPath = [bundlePath stringByAppendingPathComponent:@"/天使羽毛"];
    //
    //    [_pPGSkinPrettifyEngine StickerEnable:YES];
    //    [_pPGSkinPrettifyEngine SetStickerPackagePath:stickerPath];
    
}



@end
