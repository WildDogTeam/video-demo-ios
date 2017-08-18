//
//  WDGVideoControlView.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoControlView.h"
#define controlViewHeight [UIScreen mainScreen].bounds.size.height
#define controlViewWidth [UIScreen mainScreen].bounds.size.width
#define animationTime .5

@implementation WDGVideoControlView
{
    BOOL _microPhoneOpen;
    BOOL _cameraFront;
    NSTimer *_calculateTimer;
    NSUInteger _calculateNum;
    UILabel *_timeLabel;
    UILabel *_nameLabel;
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
        self.frame = view.bounds;
        [view addSubview:self];
    }
    self.hidden =NO;
    [view bringSubviewToFront:self];
    if(!animate) return;
    self.alpha =0;
    [UIView animateWithDuration:animationTime animations:^{
        self.alpha =1;
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:animationTime animations:^{
        self.alpha =0;
    } completion:^(BOOL finished) {
        self.hidden =YES;
        self.alpha = 1;
    }];
}

-(void)createMyView
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 25)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"pingfang SC" size:20];
    [self addSubview:nameLabel];
    nameLabel.textAlignment =NSTextAlignmentCenter;
    _nameLabel =nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame)+10, self.frame.size.width, 20)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:@"pingfang SC" size:13];
    [self addSubview:timeLabel];
    timeLabel.textAlignment =NSTextAlignmentCenter;
    _timeLabel =timeLabel;
    //比例 用于适配屏幕
//    CGFloat scale = (controlViewWidth-195)/180;
    
    CGFloat itemWidth = 60;
    CGFloat itemHeight = 60;
    CGFloat gap = (controlViewWidth - itemWidth*4)/5;
    CGFloat startCenterX = itemWidth*.5+gap;
    CGFloat itemCenterY =controlViewHeight -180+itemHeight*.5;
    
    UIView *micView = [self itemViewWithTitle:@"麦克风" imageName:@"mike-on" selectImageName:@"mike-off" selector:@selector(micButtonClick:)];
    micView.center = CGPointMake(startCenterX, itemCenterY);
    UIView *speakerView = [self itemViewWithTitle:@"扬声器" imageName:@"speaker-on" selectImageName:@"speaker-off" selector:@selector(speakerButtonClick:)];
    speakerView.center = CGPointMake(startCenterX +(gap +itemWidth), itemCenterY);
    UIView *cameraEnableView = [self itemViewWithTitle:@"摄像头" imageName:@"Camera-on" selectImageName:@"Cameraoff" selector:@selector(cameraEnableButtonClick:)];
    cameraEnableView.center = CGPointMake(startCenterX +(gap +itemWidth)*2, itemCenterY);
    UIView *cameraTurnView = [self itemViewWithTitle:@"翻转相机" imageName:@"Flip-camera" selectImageName:@"" selector:@selector(turnButtonClick)];
    cameraTurnView.center = CGPointMake(startCenterX +(gap +itemWidth)*3, itemCenterY);
    [self addSubview:micView];
    [self addSubview:speakerView];
    [self addSubview:cameraEnableView];
    [self addSubview:cameraTurnView];
    
    UIButton *hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hangupButton setImage:[UIImage imageNamed:@"挂断"] forState:UIControlStateNormal];
    hangupButton.frame = CGRectMake(0, 0, 65, 65);
    hangupButton.center = CGPointMake(controlViewWidth*.5, CGRectGetMaxY(cameraTurnView.frame)+10+hangupButton.frame.size.height*.5);
    [hangupButton addTarget:self action:@selector(hangupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hangupButton];
    UILabel *hangupLabel = [[UILabel alloc] init];
    hangupLabel.font =[UIFont fontWithName:@"pingfang SC" size:12];
    hangupLabel.textColor = [UIColor whiteColor];
    hangupLabel.text = @"挂断";
    [hangupLabel sizeToFit];
    hangupLabel.center = CGPointMake(CGRectGetMidX(hangupButton.frame), CGRectGetMaxY(hangupButton.frame)+10+CGRectGetHeight(hangupLabel.frame)*.5);
    [self addSubview:hangupLabel];
    
}

-(UIView *)itemViewWithTitle:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName selector:(SEL)selector
{
    UIView *view  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [itemBtn setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [itemBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    itemBtn.frame = CGRectMake(0, 0, 40, 40);
    itemBtn.center = CGPointMake(30, 20);
    [view addSubview:itemBtn];
    
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemBtn.frame), view.frame.size.width, 20)];
    itemLabel.textColor =[UIColor whiteColor];
    itemLabel.font = [UIFont fontWithName:@"pingfang SC" size:12];
    itemLabel.text = title;
    itemLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:itemLabel];
    
    return view;
}

-(void)micButtonClick:(UIButton *)btn
{
    _microPhoneOpen =!_microPhoneOpen;
    btn.selected = !_microPhoneOpen;
    [self.controlDelegate videoControlView:self microphoneDidClick:_microPhoneOpen];
}

-(void)speakerButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.controlDelegate videoControlView:self speakerDidOpen:btn.selected];
}

-(void)cameraEnableButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.controlDelegate videoControlView:self cameraDidOpen:btn.selected];
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
    [self stopTimer];
}

-(void)stopTimer
{
    [_calculateTimer invalidate];
    _calculateTimer = nil;
}

-(void)setOppoSiteName:(NSString *)oppoSiteName
{
    _oppoSiteName = oppoSiteName;
    _nameLabel.text = oppoSiteName;
    if(_mode == WDGVideoControlViewMode1)
        _nameLabel.hidden =YES;
}

-(void)setMode:(WDGVideoControlViewMode)mode
{
    _mode = mode;
    if(_mode == WDGVideoControlViewMode2){
        _nameLabel.hidden = NO;
        [self startTimer];
    }else{
        [self stopTimer];
        _nameLabel.hidden = YES;
    }
}
@end
