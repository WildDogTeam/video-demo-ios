//
//  WDGRecordFilesViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGSettingDetailViewController.h"
#import "WDGFileManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WDGFileManager.h"
#import "WDGBlackManager.h"
#import "WDGVideoUserItem.h"
#import <UIImageView+WebCache.h>
@interface WDGSettingDetailViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSMutableArray *detailDataList;

@end

@implementation WDGSettingDetailViewController

-(instancetype)initForTyoe:(SettingDetailType)type
{
    if(self = [super init]){
        self.detailType =type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.navigationController.interactivePopGestureRecognizer.delegate =self;
    [self loadDataList];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if(!_detailDataList.count){
        [self showEmptyView];
    }
    
}

-(void)loadDataList
{
    if(_detailType==SettingDetailTypeRecordFiles){
        _detailDataList = [NSMutableArray arrayWithArray:[[WDGFileManager sharedManager] saveFileNames]];
    }else{
        _detailDataList = [NSMutableArray arrayWithArray:[WDGBlackManager blackList]];
    }
}

-(void)showEmptyView
{
    NSString *imageName = nil;
    NSString *emptyTitle = nil;
    if(_detailType == SettingDetailTypeRecordFiles){
        imageName = @"no-call";
        emptyTitle = @"暂无录制文件";
    }else{
        imageName = @"no-user-1";
        emptyTitle = @"暂无黑名单";
    }
    [self showEmptyViewNamed:imageName size:CGSizeMake(150, 150) title:emptyTitle];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailDataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if(_detailType == SettingDetailTypeRecordFiles){
        cell.textLabel.text = _detailDataList[indexPath.row];
        NSUInteger time =[[WDGFileManager sharedManager] fileObjectForName:_detailDataList[indexPath.row]].recordTime;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",time/60,time%60];
    }else{
        WDGVideoUserItem *userItem = _detailDataList[indexPath.row];
        cell.textLabel.text = userItem.nickname.length?userItem.nickname:userItem.uid;
        if(userItem.faceUrl)
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:userItem.faceUrl] placeholderImage:[UIImage imageNamed:@"Calling"]];
        else
            cell.imageView.image = [UIImage imageNamed:@"Calling"];
        CGSize itemSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds =YES;
    }
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(_detailType == SettingDetailTypeRecordFiles){
            [[WDGFileManager sharedManager] deleteFileWithName:_detailDataList[indexPath.row]];
            _detailDataList = [NSMutableArray arrayWithArray:[[WDGFileManager sharedManager] saveFileNames]];
        }else{
            [WDGBlackManager deleteBlack:_detailDataList[indexPath.row]];
            _detailDataList = [NSMutableArray arrayWithArray:[WDGBlackManager blackList]];
        }
        if(!_detailDataList.count){
            [self showEmptyView];
        }
        [tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (IBAction)goback:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_detailType == SettingDetailTypeRecordFiles){
        NSString *filePath =[[WDGFileManager sharedManager] fileObjectForName:_detailDataList[indexPath.row]].filePath;
        NSURL *URL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:filePath]];
        MPMoviePlayerViewController  * moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
        moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.navigationController.viewControllers.count > 1;
}

@end
