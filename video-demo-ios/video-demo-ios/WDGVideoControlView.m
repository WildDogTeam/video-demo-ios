//
//  WDGVideoControlView.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoControlView.h"
#define controlViewHeight 160
#define controlViewWidth [UIScreen mainScreen].bounds.size.width
#define animationTime .5

@implementation WDGVideoControlView
{
    BOOL _microPhoneOpen;
    BOOL _cameraFront;
    NSTimer *_calculateTimer;
    NSUInteger _calculateNum;
    UILabel *_timeLabel;
}

-(instancetype)init
{
    if(self = [super initWithFrame:CGRectMake(0, 0, controlViewWidth, controlViewHeight)]){
        //默认开启麦克风 相机镜头前置
        _microPhoneOpen = YES;
        _cameraFront = YES;
        [self createMyView];

    }
    return self;
}

-(void)startTimer
{
    [self createTimer];
}

-(void)createTimer
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _calculateTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(calculate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_calculateTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)calculate
{
    _calculateNum ++;
    NSUInteger sec,min;
    sec = _calculateNum%60;
    min = _calculateNum/60;
    _timeLabel.text =[NSString stringWithFormat:@"%02lu:%02lu",min,sec];
}

-(void)showInView:(UIView *)view animate:(BOOL)animate
{
    if(self.superview != view){
        CGRect frame = self.frame;
        frame.origin.y = view.frame.size.height - self.frame.size.height;
        self.frame = frame;
        [view addSubview:self];
    }
    self.hidden =NO;
    [view bringSubviewToFront:self];
    if(!animate) return;
    self.transform = CGAffineTransformTranslate(self.transform, 0, view.frame.size.height);
    [UIView animateWithDuration:animationTime animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:animationTime animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        self.hidden =YES;
    }];
}

-(void)createMyView
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 20)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:@"pingfang SC" size:15];
    [self addSubview:timeLabel];
    timeLabel.textAlignment =NSTextAlignmentCenter;
    _timeLabel =timeLabel;
    //比例 用于适配屏幕
    CGFloat scale = (controlViewWidth-195)/180;
    
    UIButton *micButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [micButton setImage:[UIImage imageNamed:@"麦克开启"] forState:UIControlStateNormal];
    [micButton setImage:[UIImage imageNamed:@"麦克关闭"] forState:UIControlStateSelected];
    micButton.frame = CGRectMake(35*scale, 50, 65, 65);
    [micButton addTarget:self action:@selector(micButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:micButton];
    UILabel *micLabel = [[UILabel alloc] init];
    micLabel.font =[UIFont fontWithName:@"pingfang SC" size:12];
    micLabel.textColor = [UIColor whiteColor];
    micLabel.text = @"麦克风";
    [micLabel sizeToFit];
    micLabel.center = CGPointMake(CGRectGetMidX(micButton.frame), CGRectGetMaxY(micButton.frame)+15+CGRectGetHeight(micLabel.frame)*.5);
    [self addSubview:micLabel];
    
    UIButton *hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hangupButton setImage:[UIImage imageNamed:@"挂断"] forState:UIControlStateNormal];
    hangupButton.frame = CGRectMake(CGRectGetMaxX(micButton.frame)+55*scale, 50, 65, 65);
    [hangupButton addTarget:self action:@selector(hangupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hangupButton];
    UILabel *hangupLabel = [[UILabel alloc] init];
    hangupLabel.font =[UIFont fontWithName:@"pingfang SC" size:12];
    hangupLabel.textColor = [UIColor whiteColor];
    hangupLabel.text = @"取消";
    [hangupLabel sizeToFit];
    hangupLabel.center = CGPointMake(CGRectGetMidX(hangupButton.frame), CGRectGetMaxY(hangupButton.frame)+15+CGRectGetHeight(hangupLabel.frame)*.5);
    [self addSubview:hangupLabel];
    
    UIButton *turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [turnButton setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    turnButton.frame = CGRectMake(CGRectGetMaxX(hangupButton.frame)+55*scale, 50, 65, 65);
    [turnButton addTarget:self action:@selector(turnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:turnButton];
    UILabel *turnLabel = [[UILabel alloc] init];
    turnLabel.font =[UIFont fontWithName:@"pingfang SC" size:12];
    turnLabel.textColor = [UIColor whiteColor];
    turnLabel.text = @"翻转相机";
    [turnLabel sizeToFit];
    turnLabel.center = CGPointMake(CGRectGetMidX(turnButton.frame), CGRectGetMaxY(turnButton.frame)+15+CGRectGetHeight(turnLabel.frame)*.5);
    [self addSubview:turnLabel];
}

-(void)micButtonClick:(UIButton *)btn
{
    _microPhoneOpen =!_microPhoneOpen;
    btn.selected = !_microPhoneOpen;
    [self.controlDelegate videoControlView:self microphoneDidClick:_microPhoneOpen];
}

-(void)hangupButtonClick
{
    [self.controlDelegate videoControlViewDidHangup:self];
}

-(void)turnButtonClick
{
    _cameraFront = !_cameraFront;
    [self.controlDelegate videoControlView:self cameraDidTurned:_cameraFront];
}

-(void)dealloc
{
    [_calculateTimer invalidate];
    _calculateTimer = nil;
}

@end
