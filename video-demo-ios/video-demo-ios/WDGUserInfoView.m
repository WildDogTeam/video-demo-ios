//
//  WDGUserInfoView.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/11.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGUserInfoView.h"
#import <UIImageView+WebCache.h>
@implementation WDGUserInfoView

+(instancetype)viewWithName:(NSString *)name imageUrl:(NSString *)imageUrl userType:(WDGUserType)type
{
    WDGUserInfoView *infoView =[[self alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
    [infoView createViewsWithName:name imageUrl:imageUrl userType:type];
    return infoView;
}

-(void)createViewsWithName:(NSString *)name imageUrl:(NSString *)imageUrl userType:(WDGUserType)type
{
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [headView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"被叫用户"]];
    headView.center = CGPointMake(self.frame.size.width*.5, headView.frame.size.height*.5+5);
    headView.layer.cornerRadius = 30;
    headView.clipsToBounds =YES;
    [self addSubview:headView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)+10, self.frame.size.width, 26)];
    nameLabel.text =name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithName:@"pingfang SC" size:24];
    [self addSubview:nameLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+15, self.frame.size.width, 17)];
    detailLabel.text =type==WDGUserTypeCaller?@"等待对方接受邀请":@"邀你视频通话";
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont fontWithName:@"pingfang SC" size:15];
    [self addSubview:detailLabel];
}
@end
