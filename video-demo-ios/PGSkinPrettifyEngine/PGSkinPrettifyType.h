//
//  CPGSkinPrettifyType.h
//  PGSkinPrettifyEngine
//
//  Created by Huang.c on 2017/3/16.
//  Copyright © 2017年 PinGuo. All rights reserved.
//

#ifndef CPGSkinPrettifyType_h
#define CPGSkinPrettifyType_h
// 用于控制输出帧数据格式的枚举
typedef enum
{
    PGPixelFormatRGBA = 0,              // 输出 kCVPixelFormatType_32BGRA 格式的 PixelBuffer, 内部数据为 RGBA
    PGPixelFormatBGRA,                  // 输出 kCVPixelFormatType_32BGRA 格式的 PixelBuffer, 内部数据为 BGRA
    PGPixelFormatYUV420,                // 输出 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, 内部数据为 NV12
    PGPixelFormatYV12,                  // 输出 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, 内部数据为 YV12
    PGPixelFormatI420                   // 输出 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, 内部数据为 I420
} PGPixelFormat;

// 用于控制水印叠加模式的枚举
typedef enum
{
    PGBlendNormal = 1,  /* 正常 */
    PGBlendScreen,      /* 滤色 */
    PGBlendDifference,  /* 差值 */
    PGBlendMultiply,    /* 排除 */
    PGBlendOverlay      /* 叠加 */
} PGBlendMode;

// 用于控制输出旋转方向的枚举
typedef enum
{
    PGOrientationNormal = 0,           // 原样输出
    PGOrientationRightRotate90,        // 右旋90度输出（注意改变输出宽高）
    PGOrientationRightRotate180,       // 右旋180度输出
    PGOrientationRightRotate270,       // 右旋270度输出（注意改变输出宽高）
    PGOrientationFlippedMirrored,      // 翻转并镜像输出
    PGOrientationFlipped,              // 上下翻转输出
    PGOrientationMirrored,             // 左右镜像输出
    PGOrientationRightRotate90Mirrored,    // 右旋90并左右镜像输出
    PGOrientationRightRotate180Mirrored,   //右旋180并左右镜像输出
    PGOrientationRightRotate270Mirrored   //右旋270并左右镜像输出
} PGOrientation;

// 用于选择磨皮算法的枚举
typedef enum
{
    PGSoftenAlgorithmDenoise = 0,        // 降噪磨皮
    PGSoftenAlgorithmContrast,           // 细节保留磨皮
    PGSoftenAlgorithmSkinDetect          // 带肤色检测的磨皮
} PGSoftenAlgorithm;
#endif /* CPGSkinPrettifyType_h */
