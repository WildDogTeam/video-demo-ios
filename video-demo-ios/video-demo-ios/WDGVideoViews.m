//
//  WDGVideoView.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoViews.h"
#import <WilddogVideo/WDGBeautyVideoView.h>
#import <WilddogVideo/WDGLocalStream.h>
#import <WilddogVideo/WDGRemoteStream.h>
@interface WDGVideoViews()
@property (nonatomic,strong) WDGBeautyVideoView *localView;
@property (nonatomic,strong) WDGBeautyVideoView *remoteView;
@property (nonatomic,strong) WDGLocalStream *localStream;
@property (nonatomic,strong) WDGRemoteStream *remoteStream;
@property (nonatomic,copy) void(^viewChange)(BOOL isLocalViewPresent);
@end

@implementation WDGVideoViews
{
    UIView *_switchView;
    BOOL _animating;
    BOOL _showMirrorView;
}

-(instancetype)initWithViewChange:(void (^)(BOOL))viewChange
{
    if(self = [self init]){
        self.viewChange = viewChange;
        _showMirrorView =NO;
    }
    return self;
}

-(instancetype)init
{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        [self createMyView];
    }
    return self;
}

-(void)createMyView
{
    self.remoteView = [WDGBeautyVideoView new];
    self.remoteView.backgroundColor = [UIColor lightGrayColor];
    self.remoteView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.remoteView];
    self.localView = [WDGBeautyVideoView new];
    self.localView.backgroundColor = [UIColor grayColor];
    self.localView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.localView];
    UIButton *switchView = [UIButton buttonWithType:UIButtonTypeCustom];
    switchView.frame =CGRectMake(3, 33, 109, 166);
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
        if(finished){
            _animating =NO;
            _viewChange([self isPresentViewLocalView]);
        }
    }];
}

-(void)rendarViewWithLocalStream:(WDGVideoLocalStream *)localStream remoteStream:(id)remoteStream
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
    return !CGRectEqualToRect(_switchView.frame, self.localView.frame);
}

-(void)dealloc
{
    NSLog(@"videoviews dealloc");
}

-(void)showMirrorLocalView:(BOOL)showMirror
{
    if(_showMirrorView != showMirror){
        _showMirrorView = showMirror;
        if(_showMirrorView)
        self.localView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        else
        self.localView.layer.transform = CATransform3DIdentity;
    }
}

@end
