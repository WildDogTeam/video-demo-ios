 //
//  WDGOnlineViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGOnlineViewController.h"
#import "WilddogSDKManager.h"
#import "WDGAccount.h"
#import "WDGVideoReceiveViewController.h"
#import "WDGVideoCallViewController.h"
#import "UIView+MBProgressHud.h"
#import <WilddogAuth/WDGAuth.h>
#import <AVFoundation/AVFoundation.h>
#import "WDGSortedArray.h"
#import "WDGOnlineCell.h"
#import "WDGVideoItem.h"
#import <WilddogVideo/WDGConversation.h>
@interface WDGOnlineViewController ()<WDGVideoDelegate>
@end

@implementation WDGOnlineViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)showEmptyView
{
    [self showEmptyViewNamed:@"暂无用户"  size:CGSizeMake(91,90) title:@"暂无其他用户可呼叫"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.view showHUDAnimate:YES];
    [self initWilddog];
    self.navigationController.navigationBar.translucent =NO;
//    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionFooterHeight =0;
    self.tableView.sectionHeaderHeight =22;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.];
}

- (void)initWilddog
{
    NSString *uid = [WDGAccountManager currentAccount].userID;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString *faceUrl = [WDGAccountManager currentAccount].iconUrl;
    if(faceUrl) [userInfo setObject:faceUrl forKey:WDGVideoItemFaceUrlKey];
    NSString *nickName = [WDGAccountManager currentAccount].nickName;
    if(nickName) [userInfo setObject:nickName forKey:WDGVideoItemNickNameKey];
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference.root child:@".info/connected"] observeEventType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        if ([snapshot.value boolValue]) {
            if(uid){
                WDGSyncReference *ref = [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] child:uid];
                [ref setValue:userInfo withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
                    assert(error==nil);
                    [ref onDisconnectRemoveValueWithCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
                        assert(error == nil);
                    }];
                }];
            }
        }
    }];
    [[[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] child:uid] setValue:userInfo withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
        [ref onDisconnectRemoveValue];
        [WilddogSDKManager sharedManager].wilddogVideo.delegate = self;
        [self observeringOnlineUser];
    }];
    
}

- (void)observeringOnlineUser {
    
    __weak typeof(self) weakSelf = self;
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] observeEventType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        __strong typeof(weakSelf) self = weakSelf;
        NSDictionary *dic = snapshot.value;
        NSMutableArray *users = [dic.allKeys mutableCopy];
        for (NSString *uid in users) {
            if ([uid isEqualToString:[WDGAccountManager currentAccount].userID]) {
                [users removeObject:uid];
                break;
            }
        }
        NSLog(@"users-----%@",users);
        [WDGSortedArray removeAllObject];
        for (NSString *user in users) {
            WDGVideoItem *item =[WDGVideoItem new];
            item.uid = user;
            id userInfo = [dic objectForKey:user];
            if([userInfo isKindOfClass:[NSDictionary class]]){
                item.nickname = [userInfo objectForKey:WDGVideoItemNickNameKey];
                item.faceUrl = [userInfo objectForKey:WDGVideoItemFaceUrlKey];
            }
            [WDGSortedArray addObject:item];
        }
        [self.view hideHUDAnimate:YES];
        if ([WDGSortedArray sortedArray].count > 0) {
            [self hideEmptyView];
        }else{
            [self showEmptyView];
        }
        [weakSelf.tableView reloadData];
        [weakSelf observeringOnlineUserChange];
    }];
    
}

-(void)observeringOnlineUserChange
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [WDGSortedArray sortedArray].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [WDGSortedArray sortedArray][section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDGOnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onLineCell"];
    WDGVideoItem *item =[WDGSortedArray sortedArray][indexPath.section][indexPath.row];
    [cell showWithNickName:item.description iconUrl:item.faceUrl];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDGVideoItem *item = [WDGSortedArray sortedArray][indexPath.section][indexPath.row];
    if(item){
        WDGVideoViewController *vc = [WDGVideoCallViewController makeCallToUserItem:item];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [WDGSortedArray indexes];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [WDGSortedArray indexes][section];
}
#pragma mark - WDGVideoClient Dalegate

/**
 * `WDGVideo` 通过调用该方法通知当前用户收到新的视频通话邀请。
 * @param video 调用该方法的 `WDGVideo` 实例。
 * @param conversation 代表收到的视频通话的 `WDGConversation` 实例。
 * @param data 随通话邀请传递的 `NSString` 类型的数据。
 */
- (void)wilddogVideo:(WDGVideo *)video didReceiveCallWithConversation:(WDGConversation *)conversation data:(NSString * _Nullable)data{
    [WDGVideoItem requestForUid:conversation.remoteUid complete:^(WDGVideoItem *item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self getTopController] presentViewController:[WDGVideoReceiveViewController receiveCallWithConversation:conversation userItem:item] animated:YES completion:nil];
        });
    }];
    
    
    
//    [[self getTopController].view showHUDWithMessage:@"对方已取消呼叫" hideAfter:1 animate:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[self getTopController] dismissViewControllerAnimated:YES completion:NULL];
//    });

}

/**
 * `WDGVideo` 通过调用该方法通知当前用户配置 `WDGVideo` 时发生 token 错误。
 * @param video 调用该方法的 `WDGVideo` 实例。
 * @param error 代表错误信息。
 */
- (void)wilddogVideo:(WDGVideo *)video didFailWithTokenError:(NSError * _Nullable)error{
    NSLog(@"%@-----error:%@",NSStringFromSelector(_cmd),error);
}

-(UIViewController *)getTopController
{
    UIViewController *topController =self.tabBarController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)dealloc
{
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference.root child:@".info/connected"] removeAllObservers];
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] removeAllObservers];
    NSLog(@"onlineCOntroller dealloc");
}

@end
