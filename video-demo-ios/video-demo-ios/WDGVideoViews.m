//
//  WDGVideoView.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoViews.h"
#import <WilddogVideoBase/WDGBeautyVideoView.h>
#import <WilddogVideoBase/WDGLocalStream.h>
#import <WilddogVideo/WDGRemoteStream.h>

#define SwitchViewBasicFrame CGRectMake(3, 33, 109, 166)

@interface WDGVideoViews()
@property (nonatomic,strong) WDGBeautyVideoView *localView;
@property (nonatomic,strong) WDGBeautyVideoView *remoteView;
@property (nonatomic,strong) WDGLocalStream *localStream;
@property (nonatomic,strong) WDGRemoteStream *remoteStream;
@end

@implementation WDGVideoViews
{
    UIView *_switchView;
    BOOL _animating;
    BOOL _showMirror;
}

-(instancetype)initWithViewChange:(void (^)(BOOL))viewChange
{
    if(self = [self init]){
        self.viewChange = viewChange;
    }
    return self;
}

-(instancetype)init
{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        _showMirror =NO;
        [self createMyView];
        [self createSwitchView];
    }
    return self;
}

-(void)createMyView
{
    self.remoteView = [WDGBeautyVideoView new];
    self.remoteView.backgroundColor = [UIColor lightGrayColor];
    self.remoteView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.remoteView];
    self.localView = [[WDGBeautyVideoView alloc] init];
    self.localView.backgroundColor = [UIColor grayColor];
    self.localView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.localView];
    
}

-(void)createSwitchView
{
    UIButton *switchView = [UIButton buttonWithType:UIButtonTypeCustom];
    switchView.frame =SwitchViewBasicFrame;
    [switchView addTarget:self action:@selector(switchMyViews) forControlEvents:UIControlEventTouchUpInside];
    _switchView =switchView;
    [self addSubview:switchView];
}

-(void)switchMyViews
{
    if(self.localView.hidden || self.remoteView.hidden ||_animating) return;
    _animating =YES;
    BOOL localViewIsSmall = ![self isPresentViewLocalView];
    UIView *smallView = localViewIsSmall?_localView:_remoteView;
    UIView *bigView = !localViewIsSmall?_localView:_remoteView;
    [UIView animateWithDuration:.5 animations:^{
        smallView.frame = self.bounds;
    } completion:^(BOOL finished) {
        bigView.frame = _switchView.frame;
        [self bringSubviewToFront:bigView];
        [self bringSubviewToFront:_switchView];
        _animating =NO;
        if(_viewChange)
            _viewChange([self isPresentViewLocalView]);
    }];
}

-(void)rendarViewWithRemoteStream:(WDGRemoteStream *)remoteStream
{
    [self rendarViewWithLocalStream:self.localStream remoteStream:remoteStream];
}

-(void)rendarViewWithLocalStream:(WDGLocalStream *)localStream remoteStream:(WDGRemoteStream *)remoteStream
{
    if(self.localStream!=localStream){
//        [self.localStream detach:self.localView];
        self.localStream = localStream;
        if(self.localStream){
            [self.localStream attach:self.localView];
            [self showMirrorLocalView:YES];
        }
    }
    if(self.remoteStream != remoteStream){
//        [self.remoteStream detach:self.remoteView];
        self.remoteStream = remoteStream;
        if(self.remoteStream){
            [self.remoteStream attach:self.remoteView];
        }
    }
    self.localView.hidden =!localStream;
    self.remoteView.hidden =!remoteStream;
    if(self.localView.hidden){
        self.localView.frame = _switchView.frame;
        [self insertSubview:self.localView belowSubview:_switchView];
        self.remoteView.frame = self.bounds;
        return;
    }
    if(self.remoteView.hidden){
        self.remoteView.frame = _switchView.frame;
        [self insertSubview:self.remoteView belowSubview:_switchView];
        self.localView.frame = self.bounds;
        return;
    }
    [self showViews];
}

-(void)showViews
{
    [self switchMyViews];
}

-(BOOL)isPresentViewLocalView
{
    return _remoteView.frame.size.width<_localView.frame.size.width;
    return !CGRectEqualToRect(_switchView.frame, self.localView.frame);
}

-(void)dealloc
{
    NSLog(@"videoviews dealloc");
}

-(void)showMirrorLocalView:(BOOL)showMirror
{
    if(_showMirror != showMirror){
        _showMirror = showMirror;
        if(_showMirror)
        self.localView.mirror =YES;
        else
        self.localView.mirror = NO;
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat scaleX = frame.size.width / [UIScreen mainScreen].bounds.size.width;
    CGFloat scaleY = frame.size.height / [UIScreen mainScreen].bounds.size.height;
    CGRect rect = CGRectMake(SwitchViewBasicFrame.origin.x*scaleX, SwitchViewBasicFrame.origin.y*scaleY, SwitchViewBasicFrame.size.width*scaleX, SwitchViewBasicFrame.size.height*scaleY);
    if(![self isPresentViewLocalView]){
        _remoteView.frame = self.bounds;
        _localView.frame = rect;
    }else{
        _localView.frame = self.bounds;
        _remoteView.frame = rect;
    }
    _switchView.frame = rect;
}

-(id)copyWithZone:(NSZone *)zone
{
    WDGVideoViews *videoview = [[WDGVideoViews alloc] init];
    [videoview rendarViewWithLocalStream:self.localStream remoteStream:self.remoteStream];
    return videoview;
}
@end
