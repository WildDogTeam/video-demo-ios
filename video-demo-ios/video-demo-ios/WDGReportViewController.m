//
//  WDGReportViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/10/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGReportViewController.h"
#import "UIView+MBProgressHud.h"
#import "WDGVideoUserItem.h"
#import <UIImageView+WebCache.h>
@interface WDGReportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) WDGVideoUserItem *userItem;
@property (nonatomic,strong) UITextView *textView;
@end

@implementation WDGReportViewController

+(instancetype)controllerWithUserItem:(WDGVideoUserItem *)userItem
{
    WDGReportViewController *reportVC =[WDGReportViewController new];
    reportVC.userItem =userItem;
    return reportVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"举报";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.dataSource =self;
    tableView.delegate =self;
    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self.view addSubview:tableView];
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submit
{
    [self.view endEditing:YES];
    if(self.textView.text.length == 0){
        [self.view showHUDWithMessage:@"请填写举报信息" hideAfter:1 animate:YES];
        return;
    }
    [self.view showHUDAnimate:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view hideHUDAnimate:NO];
        [self.view showHUDWithMessage:@"举报成功" hideAfter:1 animate:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goback];
        });
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    if(indexPath.section == 0){
        if(self.userItem.nickname.length){
            cell.textLabel.text = self.userItem.nickname;
            cell.detailTextLabel.text = self.userItem.uid;
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
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        _textView =textView;
        [cell.contentView addSubview:textView];
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"被举报人";
    }else{
        return @"举报说明";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        return 80;
    }else{
        return 160;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
