//
//  WDGOnlineCell.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/18.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGOnlineCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface WDGOnlineCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;


@end
@implementation WDGOnlineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconView.layer.cornerRadius = 20;
    [self.iconView setClipsToBounds:YES];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.iconView.layer.cornerRadius = 20;
        [self.iconView setClipsToBounds:YES];
    }
    return self;
}

-(void)showWithNickName:(NSString *)nickname iconUrl:(NSString *)iconurl
{
    self.nickNameLabel.text = nickname;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:[UIImage imageNamed:@"Calling"]];
}
@end
