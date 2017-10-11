//
//  WDGInfoView.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGInfoView.h"

@interface WDGInfoView ()
@property (nonatomic, strong) UILabel *sizelabel;
@property (nonatomic, strong) UILabel *fpslabel;
@property (nonatomic, strong) UILabel *ratelabel;
@property (nonatomic, strong) UILabel *memorylabel;
@end

@implementation WDGInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = self.frame.size.width;
        _sizelabel = [self pingfangLabel];
        _sizelabel.frame =CGRectMake(0, 0, width, 15);
        _sizelabel.text=@"0*0px";
        UILabel *fpslabel = [self pingfangLabel];
        fpslabel.frame =CGRectMake(0, CGRectGetMaxY(_sizelabel.frame)+5, width, 15);
        fpslabel.text=@"0fps";
        _fpslabel = fpslabel;
        UILabel *ratelabel = [self pingfangLabel];
        ratelabel.frame =CGRectMake(0, CGRectGetMaxY(fpslabel.frame)+5, width, 15);
        ratelabel.text=@"0kbps";
        _ratelabel = ratelabel;
        UILabel *memorylabel = [self pingfangLabel];
        memorylabel.frame =CGRectMake(0, CGRectGetMaxY(ratelabel.frame)+5, width, 15);
        memorylabel.text=@"0MB";
        _memorylabel = memorylabel;
    }
    return self;
}


-(UILabel *)pingfangLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textAlignment = NSTextAlignmentRight;
    [label sizeToFit];
    [self addSubview:label];
    return label;
}

-(void)updateInfoWithSize:(NSString *)size fps:(NSString *)fps rate:(NSString *)rate memory:(NSString *)memory style:(PresentViewStyle)style
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _sizelabel.text =size;
        _fpslabel.text =fps;
        _ratelabel.text =rate;
        _memorylabel.text = [NSString stringWithFormat:@"%@ %@",style==PresentViewStyleSend?@"send":@"recv",memory];
    });
}
@end
