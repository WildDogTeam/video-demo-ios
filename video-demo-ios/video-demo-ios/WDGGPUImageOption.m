//
//  WDGGPUImageOption.m
//  video-demo-ios
//
//  Created by wilddog on 2018/1/30.
//  Copyright © 2018年 wilddog. All rights reserved.
//

#import "WDGGPUImageOption.h"

#import "GPUImageBeautifyFilter.h"
#import <libyuv/libyuv.h>

int WDGNV12Scale(uint8_t *psrc_buf, uint8_t *psrc_uv_buf, int stride, BOOL y_dataAlignment, int psrc_w, int psrc_h, uint8_t *pdst_buf, int pdst_w, int pdst_h);


@implementation WDGGPUImageOption
{
    GPUImageRawDataInput *_input;
    GPUImageRawDataOutput *_outPut;
    dispatch_semaphore_t _singal;
    CGFloat _p_width;
    CGFloat _p_height;
    BOOL _firstBuffer;
    CVPixelBufferRef _resultBuffer;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _firstBuffer =YES;
    }
    return self;
}

-(CVPixelBufferRef)proccessPixelBuffer:(CVPixelBufferRef)buffer
{
    _p_width = CVPixelBufferGetWidth(buffer);
    _p_height = CVPixelBufferGetHeight(buffer);
    if(_firstBuffer){
        _firstBuffer =NO;
        _input = [[GPUImageRawDataInput alloc] initWithBytes:NULL size:CGSizeMake(_p_width, _p_height)];
        _input.pixelFormat = GPUPixelFormatRGBA;
        _input.pixelType = GPUPixelTypeUByte;
        _outPut = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(_p_width, _p_height) resultsInBGRAFormat:NO];
        __weak typeof(self) WS =self;
        _outPut.newFrameAvailableBlock = ^{
            __strong typeof(WS) self =WS;
            [self->_outPut lockFramebufferForReading];
            [self data:self->_outPut.rawBytesForImage];
            [self->_outPut unlockFramebufferAfterReading];
            dispatch_semaphore_signal(self->_singal);
        };
#warning --这里可以换成自己所需的滤镜
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        //设置要渲染的区域
        [_input addTarget:beautifyFilter];
        [beautifyFilter addTarget:_outPut];
        _singal = dispatch_semaphore_create(1);
    }
    [self scale:buffer];
    dispatch_semaphore_wait(_singal, DISPATCH_TIME_FOREVER);
    return _resultBuffer;
}

-(void)data:(GLubyte *)data
{
    CVPixelBufferRef buffer = NULL;
    const void *keys[] = {
        kCVPixelBufferOpenGLESCompatibilityKey,
        kCVPixelBufferIOSurfacePropertiesKey,
    };
    const void *values[] = {
        (__bridge const void *)([NSNumber numberWithBool:YES]),
        (__bridge const void *)([NSDictionary dictionary])
    };
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 2, NULL, NULL);
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, _p_width,
                                          _p_height, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, optionsDictionary,
                                          &buffer);
    if (status!=kCVReturnSuccess) {
        NSLog(@"Operation failed");
    }
    NSParameterAssert(status == kCVReturnSuccess && buffer != NULL);
    
    CVPixelBufferLockBaseAddress(buffer,0);
    void *result_y_data = CVPixelBufferGetBaseAddressOfPlane(buffer, 0);
    void *result_uv_data = CVPixelBufferGetBaseAddressOfPlane(buffer, 1);
    uint8_t *i420_buf1 = (uint8_t *)malloc(_p_width * _p_height * 3 / 2);
    int psrc_w =(int)_p_width;
    int psrc_h =(int)_p_height;
    RGBAToI420(data, psrc_w*4 ,&i420_buf1[0],                       psrc_w,
               &i420_buf1[psrc_w * psrc_h],         psrc_w / 2,
               &i420_buf1[psrc_w * psrc_h * 5 / 4], psrc_w / 2,
               psrc_w, psrc_h);
    I420ToNV12(&i420_buf1[0],                       psrc_w,
               &i420_buf1[psrc_w * psrc_h],         psrc_w / 2,
               &i420_buf1[psrc_w * psrc_h * 5 / 4], psrc_w / 2,
               &result_y_data[0],                        psrc_w,
               &result_uv_data[0],          psrc_w,
               psrc_w,psrc_h);
    CVPixelBufferUnlockBaseAddress(buffer,0);
    free(i420_buf1);
    if(_resultBuffer){
        CVPixelBufferRelease(_resultBuffer);
    }
    _resultBuffer =buffer;
}

-(void)scale:(CVPixelBufferRef)pxBuffer
{
    
    CVPixelBufferLockBaseAddress(pxBuffer,0);
    void *pxBuffer_y_data = CVPixelBufferGetBaseAddressOfPlane(pxBuffer, 0);
    void *pxBuffer_uv_data = CVPixelBufferGetBaseAddressOfPlane(pxBuffer, 1);
    size_t wholeBytes =((uint8_t *)pxBuffer_uv_data - (uint8_t *)pxBuffer_y_data);
    BOOL y_dataAlignment =NO;
    size_t stride =0;
    if(wholeBytes % (int)_p_height == 0){
        stride =((uint8_t *)pxBuffer_uv_data - (uint8_t *)pxBuffer_y_data) / _p_height;
    }else{
        stride = _p_width;
    }
    void *result_y_data = (uint8_t *)malloc(_p_width * _p_height * 32);
    WDGNV12Scale((uint8_t *)pxBuffer_y_data,(uint8_t *)pxBuffer_uv_data, (int)stride, y_dataAlignment, (int)_p_width, (int)_p_height, (uint8_t *)result_y_data, (int)_p_width, (int)_p_height);
    CVPixelBufferUnlockBaseAddress(pxBuffer,0);
    [_input updateDataFromBytes:result_y_data size:CGSizeMake(_p_width, _p_height)];
    [_input processData];
    free(result_y_data);
}

-(void)dealloc
{
    dispatch_semaphore_signal(_singal);
    _singal =NULL;
}

@end

int WDGNV12Scale(uint8_t *psrc_buf, uint8_t *psrc_uv_buf, int stride, BOOL y_dataAlignment, int psrc_w, int psrc_h, uint8_t *pdst_buf, int pdst_w, int pdst_h)
{
    uint8_t *i420_buf1 = (uint8_t *)malloc(psrc_w * psrc_h * 3 / 2);
    NV12ToI420(&psrc_buf[0], stride, &psrc_uv_buf[0], stride, &i420_buf1[0], psrc_w, &i420_buf1[psrc_h * psrc_w], psrc_w / 2, &i420_buf1[psrc_h * psrc_w * 5 / 4], psrc_w / 2, psrc_w, psrc_h);
    
    I420ToRGBA(&i420_buf1[0], psrc_w, &i420_buf1[psrc_h * psrc_w], psrc_w / 2, &i420_buf1[psrc_h * psrc_w * 5 / 4], psrc_w / 2,
               &pdst_buf[0],  pdst_w*4,
               pdst_w, pdst_h);
    free(i420_buf1);
    return 1;
}

