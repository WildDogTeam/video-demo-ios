//
//  WDGVideoControlView.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoControlView.h"
#import "WDGTimer.h"
#define controlViewHeight [UIScreen mainScreen].bounds.size.height
#define controlViewWidth [UIScreen mainScreen].bounds.size.width
#define animationTime .5

#define itemButtonTag 10
#define itemLabelTag 11

#define micphoneItemViewTag 100
#define speakerItemViewTag 101
#define cameraEnableItemViewTag 102
#define cameraTurnItemViewTag 103

@interface WDGVideoControlView ()
@property (nonatomic,copy) UIView *inviteView;
@end

@implementation WDGVideoControlView
{
    BOOL _microPhoneOpen;
    BOOL _cameraFront;
    WDGTimer *_calculateTimer;
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
        _calculateNum =0;
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
    _calculateTimer = [WDGTimer timerWithTimeInterval:1 target:self selector:@selector(calculate) userInfo:nil];
}

-(void)calculate
{
    _calculateNum ++;
    NSUInteger sec,min;
    sec = _calculateNum%60;
    min = _calculateNum/60;
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text =[NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)min,sec];
    });
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
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    [self addSubview:nameLabel];
    nameLabel.textAlignment =NSTextAlignmentCenter;
    _nameLabel =nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame)+10, self.frame.size.width, 20)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [self addSubview:timeLabel];
    timeLabel.textAlignment =NSTextAlignmentCenter;
    _timeLabel =timeLabel;
    //比例 用于适配屏幕
//    CGFloat scale = (controlViewWidth-195)/180;
    
    CGFloat itemWidth = 60;
    CGFloat itemHeight = 60;
    CGFloat gap = (controlViewWidth - itemWidth*4)/5;
    CGFloat startCenterX = itemWidth*.5+gap;
    CGFloat itemCenterY =controlViewHeight -ControlItemsViewHeight+itemHeight*.5;
    
    UIView *micView = [self itemViewWithTitle:@"麦克风" imageName:@"mike-on" selectImageName:@"mike-off" selector:@selector(micButtonClick:)];
    micView.center = CGPointMake(startCenterX, itemCenterY);
    UIView *speakerView = [self itemViewWithTitle:@"扬声器" imageName:@"speaker-on" selectImageName:@"speaker-off" selector:@selector(speakerButtonClick:) tag:speakerItemViewTag];
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
    hangupLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
    hangupLabel.textColor = [UIColor whiteColor];
    hangupLabel.text = @"挂断";
    [hangupLabel sizeToFit];
    hangupLabel.center = CGPointMake(CGRectGetMidX(hangupButton.frame), CGRectGetMaxY(hangupButton.frame)+10+CGRectGetHeight(hangupLabel.frame)*.5);
    [self addSubview:hangupLabel];
    
    _inviteView = [self itemViewWithTitle:@"邀请他人" imageName:@"邀请他人" selectImageName:nil selector:@selector(inviteOthers)];
    _inviteView.center =CGPointMake(CGRectGetMidX(cameraTurnView.frame) , (CGRectGetMinY(hangupButton.frame)+CGRectGetMaxY(hangupLabel.frame))*.5);
    _inviteView.hidden =YES;
    [self addSubview:_inviteView];
    
//    渐变背景
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = NO;
    CGFloat y = CGRectGetMinY(micView.frame)-100;
    view.frame =CGRectMake(0,y, self.frame.size.width, self.frame.size.height-y);
    
    UIColor *colorOne = [[UIColor clearColor] colorWithAlphaComponent:0];
    UIColor *colorTwo = [[UIColor blackColor] colorWithAlphaComponent:1];
//    UIColor *colorThree = [[UIColor blackColor] colorWithAlphaComponent:1];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.frame = view.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = colors;
    gradient.locations = @[@(0.01),@(1.4)];
    [view.layer addSublayer:gradient];
    [self insertSubview:view atIndex:0];
}

-(UIView *)itemViewWithTitle:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName selector:(SEL)selector
{
    return [self itemViewWithTitle:title imageName:imageName selectImageName:selectImageName selector:selector tag:0];
}

-(UIView *)itemViewWithTitle:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName selector:(SEL)selector tag:(NSUInteger)tag
{
    UIView *view  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    view.tag =tag;
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.tag = itemButtonTag;
    [itemBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if(selectImageName.length)
        [itemBtn setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [itemBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    itemBtn.frame = CGRectMake(0, 0, 40, 40);
    itemBtn.center = CGPointMake(30, 20);
    [view addSubview:itemBtn];
    
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemBtn.frame), view.frame.size.width, 20)];
    itemLabel.textColor =[UIColor whiteColor];
    itemLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    itemLabel.text = title;
    itemLabel.tag = itemLabelTag;
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
    [self.controlDelegate videoControlView:self cameraDidOpen:!btn.selected];
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
    if(_mode == WDGVideoControlViewModeRoom){
        _inviteView.hidden =NO;
        _nameLabel.hidden = YES;
        return;
    }
    _inviteView.hidden =YES;
    if(_mode == WDGVideoControlViewMode2){
        _nameLabel.hidden = NO;
        [self startTimer];
    }else{
        [self stopTimer];
        _nameLabel.hidden = YES;
    }
}

-(NSUInteger)showTime
{
    return _calculateNum;
}

-(void)changeAudioSpeakerState:(BOOL)isSpeakerState
{
    UIView *item = [self viewWithTag:speakerItemViewTag];
    UIButton *btn = [item viewWithTag:itemButtonTag];
    btn.selected = !isSpeakerState;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)inviteOthers
{
    if([self.controlDelegate respondsToSelector:@selector(videoControlViewDidInviteOthers:)]){
        [self.controlDelegate videoControlViewDidInviteOthers:self];
    }
}
@end
