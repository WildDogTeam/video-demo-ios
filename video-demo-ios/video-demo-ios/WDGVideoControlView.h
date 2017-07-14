//
//  WDGVideoControlView.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGVideoControlView;
@protocol WDGVideoControl <NSObject>
@required
-(void)videoControlView:(WDGVideoControlView *)controlView microphoneDidClick:(BOOL)isOpened;
-(void)videoControlViewDidHangup:(WDGVideoControlView *)controlView;
-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidTurned:(BOOL)isFront;
@end
@interface WDGVideoControlView : UIView
@property (nonatomic,weak) id<WDGVideoControl> controlDelegate;
-(void)showInView:(UIView *)view animate:(BOOL)animate;
-(void)dismiss;
-(void)startTimer;
@end
