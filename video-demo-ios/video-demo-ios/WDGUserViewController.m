//
//  WDGUserViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/10/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGUserViewController.h"
#import "WDGVideoUserItem.h"
#import <UIImageView+WebCache.h>
#import "WDGVideoCallViewController.h"
#import "WDGReportViewController.h"
#import "WDGImageTool.h"
#import "WDGBlackManager.h"
#import "WDGVideoControllerManager.h"
//@interface WDGBasicCell :UITableViewCell
//@property (nonatomic,copy) NSString *title;
//@property (nonatomic,strong) UIImage *headImg;
//@property (nonatomic,copy) NSString *detailTitle;
//@end
//
//@implementation WDGBasicCell
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self initMyView];
//    }
//    return self;
//}
//
//-(void)initMyView
//{
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 22, 22)];
//}
//
//@end



@interface WDGUserViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic,strong) WDGVideoUserItem *userItem;
@end

@implementation WDGUserViewController
{
    UITableView *_tableView;
}

+(instancetype)controllerWithUserItem:(WDGVideoUserItem *)userItem
{
    WDGUserViewController *userController = [[self alloc] init];
    userController.userItem = userItem;
    userController.hidesBottomBarWhenPushed = YES;
    return userController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.dataSource =self;
    tableView.delegate =self;
    [self.view addSubview:tableView];
    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    _tableView =tableView;
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setTitle:@"视频通话" forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callUser) forControlEvents:UIControlEventTouchUpInside];
    callBtn.frame = CGRectMake(0, 0, 241, 41);
    callBtn.center =CGPointMake(self.view.center.x, self.view.frame.size.height-64-20-.5*CGRectGetHeight(callBtn.frame));
    callBtn.layer.cornerRadius = CGRectGetHeight(callBtn.frame)*.5;
    callBtn.clipsToBounds =YES;
    UIColor *normalColor = [UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.];
    UIColor *highlightColor = [UIColor colorWithRed:0xf0/255. green:0x91/255. blue:0x6e/255. alpha:1.];
    [callBtn setBackgroundImage:[WDGImageTool imageFromColor:normalColor size:callBtn.frame.size] forState:UIControlStateNormal];
    [callBtn setBackgroundImage:[WDGImageTool imageFromColor:highlightColor size:callBtn.frame.size] forState:UIControlStateHighlighted];
    [self.view addSubview:callBtn];
    [self.view bringSubviewToFront:callBtn];
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callUser
{
//    WDGVideoCallViewController *controller = [WDGVideoCallViewController makeCallToUserItem:self.userItem];
//    [self presentViewController:controller animated:YES completion:nil];
    [[WDGVideoControllerManager sharedManager] makeCallToUserItem:self.userItem inViewController:self];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];;
    if(indexPath.section == 0){
        if(self.userItem.nickname.length){
            cell.textLabel.text = self.userItem.nickname;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"ID:%@",self.userItem.uid];
        }else{
            cell.textLabel.text = self.userItem.uid;
        }
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.userItem.faceUrl] placeholderImage:[UIImage imageNamed:@"Calling"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGSize itemSize = CGSizeMake(60, 60);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.imageView.layer.cornerRadius = 30;
        cell.imageView.layer.masksToBounds =YES;
    }else{
        if(indexPath.row == 0){
            cell.imageView.image =[UIImage imageNamed:@"Blacklist"];
            cell.textLabel.text = @"加入黑名单";
        }else{
            cell.imageView.image =[UIImage imageNamed:@"report"];
            cell.textLabel.text = @"举报";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        return 80;
    }else{
        return 55;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        if(indexPath.row==0){
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"加入黑名单，你将无法与对方视频通话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"加入黑名单" otherButtonTitles: nil];
            [action showInView:self.view];
        }else{
            UIViewController *vc =[WDGReportViewController controllerWithUserItem:self.userItem];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [WDGBlackManager addBlack:self.userItem];
    }
}

@end
