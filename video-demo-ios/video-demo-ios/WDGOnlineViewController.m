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

@interface WDGOnlineViewController ()<WDGVideoClientDelegate>
@property (nonatomic, strong) NSArray *onLineUsers;
@end

@implementation WDGOnlineViewController

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self showEmptyView];
    [self initWilddog];
    self.navigationController.navigationBar.translucent =NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}

-(void)showEmptyView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.view.frame.size.height-150)];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"暂无用户"];
    imageView.frame = CGRectMake(0, 0, 91, 90);
    imageView.center = CGPointMake(bgView.center.x, 180);
    [bgView addSubview:imageView];
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, bgView.frame.size.width, 20)];
    emptyLabel.text =@"暂无其他用户可呼叫";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont fontWithName:@"pingfang SC" size:15];
    emptyLabel.textColor = [UIColor colorWithRed:0x33/255. green:0x33/255. blue:0x33/255. alpha:1.];
    [bgView addSubview:emptyLabel];
    self.tableView.tableHeaderView =bgView;
}

-(void)hideEmptyView
{
    self.tableView.tableHeaderView = nil;
}

- (void)initWilddog
{
    NSString *uid = [WDGAccountManager currentAccount].userID;
    [[[[WDGSync sync] reference] child:@".info/connected"] observeEventType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        if ([snapshot.value boolValue]) {
            if(uid){
                WDGSyncReference *ref = [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] child:uid];
                [ref setValue:@YES withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
                    assert(error==nil);
                    [ref onDisconnectRemoveValueWithCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
                        assert(error == nil);
                    }];
                }];
            }
        }
    }];
    [[[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] child:uid] setValue:@YES withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
        [ref onDisconnectRemoveValue];
        [WilddogSDKManager sharedManager].wilddogVideoClient.delegate = self;
        [self observeringOnlineUser];
    }];

}

- (void)observeringOnlineUser {
    
    __weak typeof(self) weakSelf = self;
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] observeEventType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dic = snapshot.value;
        NSMutableArray *users = [dic.allKeys mutableCopy];
        for (NSString *uid in users) {
            if ([uid isEqualToString:[WDGAccountManager currentAccount].userID]) {
                [users removeObject:uid];
                break;
            }
        }
        NSLog(@"users-----%@",users);
        self.onLineUsers = users;
        if (self.onLineUsers.count > 0) {
            [self hideEmptyView];
        }else{
            [self showEmptyView];
        }
        [weakSelf.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _onLineUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.font = [UIFont fontWithName:@"pingfang SC" size:15];
    cell.textLabel.text = _onLineUsers[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uid = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if(uid.length){
        WDGVideoViewController *vc = [WDGVideoCallViewController makeCallToUserId:uid];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 15)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

#pragma mark - WDGVideoClient Dalegate
- (void)wilddogVideoClient:(WDGVideoClient *)videoClient didReceiveInvite:(WDGVideoIncomingInvite *)invite {
    [[self getTopController] presentViewController:[WDGVideoReceiveViewController receiveCallWithIncomingInvite:invite] animated:YES completion:nil];
}

- (void)wilddogVideoClient:(WDGVideoClient *)videoClient inviteDidCancel:(WDGVideoIncomingInvite *)invite {
    [[self getTopController].view showHUDWithMessage:@"对方已取消呼叫" hideAfter:1 animate:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self getTopController] dismissViewControllerAnimated:YES completion:NULL];
    });
}

-(UIViewController *)getTopController
{
    UIViewController *topController =self.tabBarController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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

@end
