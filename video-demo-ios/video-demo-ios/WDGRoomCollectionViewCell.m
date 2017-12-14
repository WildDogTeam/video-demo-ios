//
//  WDGRoomCollectionViewCell.m
//  video-demo-ios
//
//  Created by han wp on 2017/11/23.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGRoomCollectionViewCell.h"
#import <WilddogVideoBase/WilddogVideoBase.h>

@implementation WDGRoomCollectionViewCellLayout

@end

@interface WDGRoomCollectionViewCell ()
@property (nonatomic,strong) WDGVideoView *videoView;
@end

@implementation WDGRoomCollectionViewCell

+(NSString *)identifier
{
    return NSStringFromClass(self);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initViews];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews
{
    WDGVideoView *videoView = [[WDGBeautyVideoView alloc] init];
    videoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:videoView];
    self.videoView = videoView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(!CGRectEqualToRect(self.videoView.frame, self.contentView.bounds)){
        self.videoView.frame = self.contentView.bounds;
        if(self.layout.cornerRadius)
            [self setVideoViewCorner];
    }
}

-(void)setVideoViewCorner
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.videoView.bounds cornerRadius:self.layout.cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.videoView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.videoView.layer.mask = maskLayer;
}

-(void)setLayout:(WDGRoomCollectionViewCellLayout *)layout
{
    _layout =layout;
    NSLog(@"%d",layout.needMirror);
    self.videoView.mirror = layout.needMirror;
    [layout.stream attach:self.videoView];
}

@end
