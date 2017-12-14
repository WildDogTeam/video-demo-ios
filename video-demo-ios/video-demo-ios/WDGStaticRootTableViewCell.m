//
//  WDGStaticRootTableViewCell.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGStaticRootTableViewCell.h"
#import "WDGAccount.h"
#import "UIView+MBProgressHud.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation WDGStaticRootTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self setNeedsLayout];
        [self layoutIfNeeded];
        self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size ={22,22};
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.imageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end

@implementation WDGStaticCopyTableViewCell
{
    UIButton *_copyButton;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[WDGAccountManager currentAccount].iconUrl] placeholderImage:[UIImage imageNamed:@"Calling"]];
    self.textLabel.text =[WDGAccountManager currentAccount].nickName;
    self.detailTextLabel.text =[NSString stringWithFormat:@"ID:%@",[WDGAccountManager currentAccount].userID];
    UIButton *copyButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [copyButton setTitleColor:[UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.] forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor colorWithRed:0xf0/255. green:0x91/255. blue:0x6e/255. alpha:1.] forState:UIControlStateHighlighted];
    [copyButton addTarget:self action:@selector(copyID) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:copyButton];
    _copyButton = copyButton;
    copyButton.hidden =YES;
    _copyButton.frame = CGRectMake(0, 0, 60, 40);
    self.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.imageView.layer.cornerRadius = 30;
    self.imageView.clipsToBounds =YES;
}

-(void)copyID
{
    [UIPasteboard generalPasteboard].string = [WDGAccountManager currentAccount].userID;
    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"已复制" hideAfter:1 animate:YES];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _copyButton.center = CGPointMake(self.frame.size.width-22-CGRectGetWidth(_copyButton.frame)*.5, CGRectGetHeight(self.contentView.frame)*.5);
//    self.detailTextLabel.frame = CGRectMake(CGRectGetMinX(_copyButton.frame)-205, CGRectGetMinY(self.detailTextLabel.frame), 200, CGRectGetHeight(self.detailTextLabel.frame));
    CGSize itemSize = CGSizeMake(60 , 60);
    UIGraphicsBeginImageContextWithOptions(itemSize,NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

@end
