
//
//  WDGFunctionView.m
//  video-demo-ios
//
//  Created by han wp on 2017/10/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGFunctionView.h"
#import "WDGInfoView.h"

@interface WDGFunctionView()
@property (nonatomic,strong) UIButton *infoButton;
@property (nonatomic,strong) UIButton *recordButton;
@property (nonatomic,strong) UIButton *smallWinBtn;
@end

@implementation WDGFunctionView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 150, 250)];
    if (self) {
        [self createViews];
    }
    return self;
}

-(void)createViews
{
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoButton.frame =CGRectMake(self.frame.size.width -33-15, 0, 33, 33);
    [infoButton setImage:[UIImage imageNamed:@"说明"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:infoButton];
    //infoButton.hidden =YES;
    _infoButton =infoButton;
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame =CGRectMake(CGRectGetMinX(_infoButton.frame), CGRectGetMaxY(infoButton.frame)+21, 33, 33);
    [recordButton setImage:[UIImage imageNamed:@"录制文件-未点击"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"录制文件-点击"] forState:UIControlStateSelected];
    [recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:recordButton];
    _recordButton =recordButton;
    //recordButton.hidden =YES;
    
    UIButton *smallWinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    smallWinBtn.frame =CGRectMake(CGRectGetMinX(_infoButton.frame), CGRectGetMaxY(recordButton.frame)+21, 33, 33);
    [smallWinBtn setImage:[UIImage imageNamed:@"Full-screen"] forState:UIControlStateNormal];
    [smallWinBtn addTarget:self action:@selector(smallWinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:smallWinBtn];
    _smallWinBtn =smallWinBtn;
    //smallWinBtn.hidden =YES;
}

-(WDGInfoView *)infoView
{
    if(!_infoView){
//        CGFloat infoViewWidth = 150;
//        CGFloat infoViewHeight =100;
        _infoView = [[WDGInfoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-10, self.frame.size.height)];
    }
    return _infoView;
}

-(UILabel *)timeLabel
{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.frame = CGRectMake(CGRectGetMinX(self.recordButton.frame)-160, CGRectGetMinY(self.recordButton.frame), 150, CGRectGetHeight(self.recordButton.frame));
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(void)showInfoView
{
    [self addSubview:self.infoView];
    self.infoButton.hidden = YES;
    self.recordButton.hidden = YES;
    self.smallWinBtn.hidden =YES;
    if(_timeLabel){
        self.timeLabel.hidden =YES;
    }
}

-(void)hideInfoView
{
    [self.infoView removeFromSuperview];
    self.infoView =nil;
    self.infoButton.hidden = NO;
    self.recordButton.hidden = NO;
    self.smallWinBtn.hidden =NO;
    if(_timeLabel){
        self.timeLabel.hidden =NO;
    }
}

-(void)startRecord
{
    _recordButton.selected = !_recordButton.selected;
    if(_recordButton.selected){
        [self changeRecordBtnSelectAppearance];
    }else{
        [self returnRecordBtnAppearance];
    }
    if([self.delegate respondsToSelector:@selector(functionViewRecordSuccessStart:recordState:)]){
        BOOL success = [self.delegate functionViewRecordSuccessStart:self recordState:_recordButton.selected];
        if(!success){
            [self returnRecordBtnAppearance];
        }
    }
}

-(void)smallWinBtnClick
{
    if([self.delegate respondsToSelector:@selector(functionViewShowSmallWindowBtnDidClick:)]){
        [self.delegate functionViewShowSmallWindowBtnDidClick:self];
    }
}

-(void)returnRecordBtnAppearance
{
    [_timeLabel removeFromSuperview];
    _timeLabel = nil;
    _recordButton.selected =NO;
    [_recordButton setBackgroundColor:[UIColor clearColor]];
    _recordButton.layer.cornerRadius = 0;
    [_recordButton setClipsToBounds:NO];
}

-(void)changeRecordBtnSelectAppearance
{
    [_recordButton setBackgroundColor:[UIColor colorWithWhite:1. alpha:.8]];
    _recordButton.layer.cornerRadius = _recordButton.frame.size.width*.5;
    [_recordButton setClipsToBounds:YES];
}
@end
