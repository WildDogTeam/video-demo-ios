//
//  WDGVideoControlView.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGVideoControlView;

#define ControlItemsViewHeight 180

typedef NS_ENUM(NSUInteger,WDGVideoControlViewMode){
    WDGVideoControlViewMode1, //没有上方nameLabel，timeLabel
    WDGVideoControlViewMode2,
    WDGVideoControlViewModeRoom //room竖屏模式
};

@protocol WDGVideoControl <NSObject>
@required
-(void)videoControlView:(WDGVideoControlView *)controlView microphoneDidClick:(BOOL)isOpened;
-(void)videoControlViewDidHangup:(WDGVideoControlView *)controlView;
-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidTurned:(BOOL)isFront;
-(void)videoControlView:(WDGVideoControlView *)controlView speakerDidOpen:(BOOL)micphoneOpened;
-(void)videoControlView:(WDGVideoControlView *)controlView cameraDidOpen:(BOOL)cameraOpen;
@optional
-(void)videoControlViewDidInviteOthers:(WDGVideoControlView *)controlView;
@end
@interface WDGVideoControlView : UIView
@property (nonatomic,weak) id<WDGVideoControl> controlDelegate;
@property (nonatomic,copy) NSString *oppoSiteName;
@property (nonatomic,assign) WDGVideoControlViewMode mode;
-(void)changeAudioSpeakerState:(BOOL)isSpeakerState;
-(void)showInView:(UIView *)view animate:(BOOL)animate;
-(void)dismiss;
-(NSUInteger)showTime;
@end
