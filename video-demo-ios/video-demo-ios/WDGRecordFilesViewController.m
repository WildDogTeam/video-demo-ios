//
//  WDGRecordFilesViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGRecordFilesViewController.h"
#import "WDGFileManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WDGFileManager.h"

#define WDGVideoSDKVersion 
#define WDGSyncSDKVersion 
#define WDGAuthSDKVersion
#define Camera360Version
#define TUSDKVersion 

@interface WDGRecordFilesViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSMutableArray *recordFiles;
@end

@implementation WDGRecordFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate =self;
    _recordFiles = [NSMutableArray arrayWithArray:[[WDGFileManager sharedManager] saveFileNames]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if(!_recordFiles.count){
        [self showEmptyView];
    }
}

-(void)showEmptyView
{
    [self showEmptyViewNamed:@"no-call" size:CGSizeMake(150, 150) title:@"暂无录制文件"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordFiles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = _recordFiles[indexPath.row];
    NSUInteger time =[[WDGFileManager sharedManager] fileObjectForName:_recordFiles[indexPath.row]].recordTime;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",time/60/60,time/60,time%60];
    cell.textLabel.font = [UIFont fontWithName:@"pingfang SC" size:15];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[WDGFileManager sharedManager] deleteFileWithName:_recordFiles[indexPath.row]];
        _recordFiles = [NSMutableArray arrayWithArray:[[WDGFileManager sharedManager] saveFileNames]];
        if(!_recordFiles.count){
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
    NSString *filePath =[[WDGFileManager sharedManager] fileObjectForName:_recordFiles[indexPath.row]].filePath;
    NSURL *URL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:filePath]];
    MPMoviePlayerViewController  * moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
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
