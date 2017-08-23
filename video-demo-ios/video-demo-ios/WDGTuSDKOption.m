//
//  WDGTUSDKOption.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/13.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGTuSDKOption.h"
#import <UIKit/UIKit.h>
#if __has_include(<TuSDK/TuSDK.h>)
#import <TuSDK/TuSDK.h>
#endif
#if __has_include(<TuSDKVideoLite/TuSDKFilterProcessor.h>)
#import <TuSDKVideoLite/TuSDKFilterProcessor.h>
#endif
#if __has_include(<TuSDK/TuSDK.h>)
@interface WDGTuSDKOption()<TuSDKFilterManagerDelegate>
#else
@interface WDGTuSDKOption()
#endif
@end
@implementation WDGTuSDKOption
#if __has_include(<TuSDKVideoLite/TuSDKFilterProcessor.h>)
{
    TuSDKFilterProcessor *_processor;
    dispatch_queue_t _myQueue;
    CVPixelBufferRef _ref;
}
#endif
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTUSDK];
        _myQueue = dispatch_queue_create("han", DISPATCH_QUEUE_SERIAL);

    }
    return self;
}

#if __has_include(<TuSDK/TuSDK.h>)
-(void)initTUSDK
{
    [TuSDK initSdkWithAppKey:WDGTUSDKAppKey];
    [TuSDK checkManagerWithDelegate:self];
    
}

-(void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager
{
#if __has_include(<TuSDKVideoLite/TuSDKFilterProcessor.h>)
    _processor = [[TuSDKFilterProcessor alloc] initWithFormatType:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange adjustByVideoOrientation:YES];
    _processor.outputPixelFormatType = lsqFormatTypeYUV420F;
    [_processor switchFilterWithCode:@"SkinNature"];
#endif
}

#else
-(void)initTUSDK{}
#endif

-(CVPixelBufferRef)proccessPixelBuffer:(CVPixelBufferRef)buffer
{
#if __has_include(<TuSDKVideoLite/TuSDKFilterProcessor.h>)
    __block CVPixelBufferRef ref = NULL;
    dispatch_sync(_myQueue, ^{
        if(_processor){
            if(_ref)
                CVPixelBufferRelease(_ref);
            ref = [_processor syncProcessPixelBuffer:buffer];
            _ref =ref;
            
            [_processor destroyFrameData];
        }else{
            ref = buffer;
        }
        
    });
    return ref;
    //    CVPixelBufferRetain(buffer);
    //    return buffer;
#else
    return buffer;
#endif
}









// pixelBuffer <---> UIImage
-(UIImage*)pixelBufferToImage:(CVPixelBufferRef) pixelBuffer{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return uiImage;
}

- (CVPixelBufferRef)pixelBufferFromUIImage:(UIImage *)uiimage
{
    if (!uiimage) {
        return nil;
    }
    CGImageRef image = uiimage.CGImage;
    NSDictionary *options = @{
                              (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
                              (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                              };
    
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, CGImageGetWidth(image),
                                          CGImageGetHeight(image), kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    if (status!=kCVReturnSuccess) {
        NSLog(@"Operation failed");
    }
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, CGImageGetWidth(image),
                                                 CGImageGetHeight(image), 8, 4*CGImageGetWidth(image), rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    //    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    //    CGAffineTransform flipVertical = CGAffineTransformMake( 1, 0, 0, -1, 0, CGImageGetHeight(image) );
    //    CGContextConcatCTM(context, flipVertical);
    //    CGAffineTransform flipHorizontal = CGAffineTransformMake( -1.0, 0.0, 0.0, 1.0, CGImageGetWidth(image), 0.0 );
    //    CGContextConcatCTM(context, flipHorizontal);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}



@end
