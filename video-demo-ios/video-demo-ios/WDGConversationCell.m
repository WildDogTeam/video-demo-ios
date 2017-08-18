//
//  WDGConversationCell.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/14.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGConversationCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface WDGConversationCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end
@implementation WDGConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconVIew.layer.cornerRadius = 20;
    [self.iconVIew setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showWithNickName:(NSString *)nickname time:(NSString *)time detail:(NSString *)detail iconUrl:(NSString *)iconurl
{
    self.nickNameLabel.text = nickname;
    self.timeLabel.text =time;
    self.detailLabel.text =detail;
    [self.iconVIew sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:[UIImage imageNamed:@"Calling"]];
}

@end
