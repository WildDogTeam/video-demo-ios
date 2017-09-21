//
//  WDGCamera360Option.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/13.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGCamera360Option.h"
#import "PGSkinPrettifyEngine.h"

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
//    double start = [[NSDate date] timeIntervalSince1970];
    
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
    
    [_pPGSkinPrettifyEngine InitEngineWithKey:WDGCamera360AppKey];
    
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
