//
//  PGSkinPrettifyEngine.h
//  PGSkinPrettifyEngine
//
//  Created by ZhangJingQi on 16/5/26.
//  Copyright © 2016-2017年 Chengdu PinGuo Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "PGSkinPrettifyType.h" 
// Tips: 本引擎依赖 libz， AVFoundation.framework 以及 CoreMedia.framework

// 用于实时预览美肤的 View , 继承至 UIView

@class PGOglView;

// 美肤结果输出委托，当美肤完成时，引擎会回调此委托，传入美肤结果
@protocol PGSkinPrettifyDelegate <NSObject>

- (void) PGSkinPrettifyResultOutput:(CVPixelBufferRef)pixelBuffer;

@end

@interface PGSkinPrettifyEngine : NSObject

/*
 描述：初始化引擎
 返回值：成功返回 YES，失败或已经初始化过返回 NO
 参数：pKey - 许可密钥
 */
- (BOOL) InitEngineWithKey:(NSString*) pKey;

/*
 描述：根据所设置的参数，运行引擎
 返回值：成功返回 YES, 失败返回 NO
 参数：无
 */
- (BOOL) RunEngine;

/*
 描述：暂停引擎运行，调用后所有接口调用均被忽略，避免 App 切换至后台时产生新的 drawcall 而引起崩溃
 返回值：无
 参数：无
 */
- (void) PauseEngine;

/*
 描述：恢复引擎的运行
 返回值：无
 参数：无
 */
- (void) ResumeEngine;

/*
 描述：销毁引擎
 返回值：无
 参数：无
 */
- (void) DestroyEngine;

/*
 描述：设置输入帧，纯美颜、滤镜可调用此接口，pInputPixel 建议使 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange，内存使用更少。
 返回值：无
 参数：pInputPixel - 相机回调所给的预览帧，支持 kCVPixelFormatType_32BGRA 与 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange 两种格式的输入
 */
- (void) SetInputFrameByCVImage:(CVPixelBufferRef)pInputPixel;

/*
 描述：设置一个方向，用于校正输入的预览帧
 返回值：无
 参数：eAdjustInputOrient - 方向值
 */
- (void) SetOrientForAdjustInput:(PGOrientation)eAdjustInputOrient;

/*
 描述：设置一个矩阵用于调整输入帧，使用此方法意味着将输入的预处理变换操作交由调用者控制，调用此方法后会影响 SetOrientForAdjustInput 产生的设置
 返回值：无
 参数：pMatrix - MVP矩阵
 */
- (void) SetMatrixForAdjustInput:(float *)pMatrix;

/*
 描述：设置一个尺寸，用于调整输入帧的宽高，也是最终输出帧的宽高
 返回值：无
 参数：sSize - 宽和高
 */
- (void) SetSizeForAdjustInput:(CGSize)sSize;

/*
 描述：设置美肤步骤中磨皮的强度
 返回值：无
 参数：iSoftenStrength - 磨皮强度，范围 0 - 100
 */
- (void) SetSkinSoftenStrength:(int)iSoftenStrength;

/*
 描述：设置美肤算法
 返回值：无
 参数：eSoftenAlgorithm - 美肤算法类型
 */
- (void) SetSkinSoftenAlgorithm:(PGSoftenAlgorithm)eSoftenAlgorithm;

/*
 描述：设置调色滤镜
 返回值：无
 参数：pName - 滤镜名称
 */
- (void) SetColorFilterByName:(NSString *)pName;

/*
 描述：设置调色滤镜强度
 返回值：无
 参数：iStrength - 调色滤镜强度，范围 0 - 100
 */
- (void) SetColorFilterStrength:(int)iStrength;

/*
 描述：移除当前滤镜
 返回值：无
 */
- (void) RemoveFilter;

/*
 描述：设置美肤步骤中的肤色调整参数
 返回值：无
 参数：fPinking - 粉嫩程度， fWhitening - 白晰程度，fRedden - 红润程度，范围都是0.0 - 1.0
 */
- (void) SetSkinColor:(float)fPinking Whitening:(float)fWhitening Redden:(float)fRedden;

/*
 描述：设置美肤结果的输出方向
 返回值：无
 参数：eOutputOrientation - 方向值
 */
- (void) SetOutputOrientation:(PGOrientation)eOutputOrientation;

/*
 描述：设置一个矩阵用于调节输出，使用此方法意味着将输出的变换操作交由调用者控制，调用此方法后会影响 SetOutputOrientation 产生的设置
 返回值：无
 参数：pMatrix - MVP 矩阵
 */
- (void) SetMatrixForAdjustOutput:(float *)pMatrix;

/*
 描述：设置美肤结果的输出格式
 返回值：无
 参数：eOutFormat - 输出的色彩格式
 */
- (void) SetOutputFormat:(PGPixelFormat)eOutFormat;

/*
 描述：设置美肤结果的输出回调
 返回值：无
 参数：outputCallback - 委托
 */
- (void) SetSkinPrettifyResultDelegate:(id <PGSkinPrettifyDelegate>)outputCallback;

/*
 描述：从路径设置水印图像，支持 jpeg 和 png，注意，如果将png打包到app中时，在xcode中开启了png压缩和去除metadata，会导致libpng解码出错
 返回值：成功返回 YES，失败返回 NO
 参数：pImagePath - 图像路径，iMode - 水印混合模式
 */
- (BOOL) SetWatermarkByPath:(NSString *)pImagePath Blend:(PGBlendMode)iMode;

/*
 描述：设置水印
 返回值：成功返回 YES，失败返回 NO
 参数：pImage - UIImage对象，iMode - 水印混合模式
 */
- (BOOL) SetWatermarkByImage:(UIImage *)pImage Blend:(PGBlendMode)iMode;

/*
 描述：设置水印的位置及翻转和镜像参数，坐标系是左下角为原点，横向为x轴，纵向为y轴，范围均为 0 - 1
 返回值：成功返回 YES，失败返回 NO
 参数：fLeft, fTop - 左上角坐标， fWidth, fHeight - 宽和高， fFlipped, fMirrored - 上下翻转和左右镜像
 */
- (BOOL) SetParamForAdjustWatermark:(float)fLeft Top:(float)fTop Width:(float)fWidth Height:(float)fHeight Flipped:(float)fFlipped Mirrored:(float)fMirrored;

/*
 描述：设置水印不透明度
 返回值：无
 参数：iBlendStrength - 水印不透明度，范围 0 - 100
 */
- (void) SetWatermarkStrength:(int)iBlendStrength;

/*
 描述：主动获取美肤结果
 返回值：无
 参数：pResultBuffer - 指向 CVPixelBufferRef 的指针
 */
- (void) GetSkinPrettifyResult:(CVPixelBufferRef *)pResultBuffer;

/*
 描述：获取输出纹理的 ID
 返回值：输出纹理的 ID
 参数：无
 */
- (int) GetOutputTextureID;

/*
 描述：获取美肤 SDK 内部的 EAGLContext
 返回值：美肤 SDK 内部的 EAGLContext
 参数：无
 */
- (EAGLContext *) GetInternalEAGLContext;

/*
 描述：创建一个预览美肤效果的 View ,返回的 View 会在 DestroyEngine 时销毁，不需要外部销毁
 返回值：所创建的 PGOglView 指针
 参数：View 的尺寸
 */
- (PGOglView *) PGOglViewCreateWithFrame:(CGRect)sFrame;

/*
 描述：将美肤结果刷新到 PGOglView
 返回值：成功返回 YES，引擎未初始化，或 View 未成功创建返回 NO
 参数：无
 */
- (BOOL) PGOglViewPresent;

/*
 描述：设置一个矩阵用于控制显示画面的变换
 返回值：成功返回 YES
 参数：pMatrix - MVP矩阵
 */
- (BOOL) PGOglViewSetMVPMatrix:(float *)pMatrix;

/*
 描述：将美肤结果缓冲区显示到 PGOglView
 返回值：成功返回 YES，引擎未初始化，或 View 未成功创建返回 NO
 参数：无
 */
- (BOOL) PGOglViewRenderResult;

/*
 描述：将显示内容左右镜像
 返回值：无
 参数：bMirrored - 为YES时显示内容会左右镜像
 */
- (void) PGOglViewMirrored:(BOOL)bMirrored;

/*
 描述：外部更改了 PGOglView 的 Size 后通过调用此方法通知引擎更新 PGOglView 相关的组件
 返回值：无
 参数：无
 */
- (void) PGOglViewSizeChanged;
@end


