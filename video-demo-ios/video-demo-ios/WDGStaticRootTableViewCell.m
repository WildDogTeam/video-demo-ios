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
@implementation WDGStaticRootTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.textLabel.font = [UIFont fontWithName:@"pingfang SC" size:15];

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
    self.detailTextLabel.text =[WDGAccountManager currentAccount].userID;
    UIButton *copyButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont fontWithName:@"pingfang SC" size:14];
    [copyButton setTitleColor:[UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.] forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor colorWithRed:0xf0/255. green:0x91/255. blue:0x6e/255. alpha:1.] forState:UIControlStateHighlighted];
    [copyButton addTarget:self action:@selector(copyID) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:copyButton];
    _copyButton = copyButton;
    _copyButton.frame = CGRectMake(0, 0, 40, 14);
    self.detailTextLabel.font = [UIFont fontWithName:@"pingfang SC" size:12];
}

-(void)copyID
{
    [UIPasteboard generalPasteboard].string = self.detailTextLabel.text;
    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"已复制" hideAfter:1 animate:YES];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _copyButton.center = CGPointMake(self.frame.size.width-15-CGRectGetWidth(_copyButton.frame)*.5, CGRectGetHeight(self.contentView.frame)*.5);
    self.detailTextLabel.frame = CGRectMake(CGRectGetMinX(_copyButton.frame)-205, CGRectGetMinY(self.detailTextLabel.frame), 200, CGRectGetHeight(self.detailTextLabel.frame));
}

@end
