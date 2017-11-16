//
//  ViewController.m
//  WilddogVideoDemo
//
//  Created by han wp on 2017/10/12.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "ViewController.h"
#import <WilddogAuth/WilddogAuth.h>
#import <WilddogSync/WilddogSync.h>
#import <WilddogCore/WilddogCore.h>
#import <WDGVideoCallKit/WDGVideoCallKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define WDGAPPSyncId     @""
#define WDGAPPVideoId    @""

@interface ViewController ()
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,strong) NSMutableArray *onlineUsers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [WDGApp configureWithOptions:[[WDGOptions alloc] initWithSyncURL:[NSString stringWithFormat:@"https://%@.wilddogio.com", WDGAPPSyncId]]];
    
    // 使用VideoSDK前必须经过WilddogAuth身份认证
    [[WDGAuth auth] signOut:nil];
    
    __weak __typeof__(self) weakSelf = self;
    [[WDGAuth auth] signInAnonymouslyWithCompletion:^(WDGUser * _Nullable user, NSError * _Nullable error) {
        __strong __typeof__(self) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        if (error) {
            NSLog(@"请在控制台为您的AppID开启匿名登录功能，错误信息: %@", error);
            return;
        }
        [user getTokenWithCompletion:^(NSString * _Nullable idToken, NSError * _Nullable error) {
            strongSelf.uid = user.uid;
            strongSelf.token = idToken;
            strongSelf.title =@"OnlineUsers";
            [strongSelf setupOnlineUserMonitoring];
            WDGVideoCallOption *option = [WDGVideoCallOption new];
            option.videoId = WDGAPPVideoId;
            option.token =idToken;
            [[WDGVideoManager sharedManager] configWithOption:option];
        }];
    }];

}

-(void)setupOnlineUserMonitoring
{
    [[[[[WDGSync sync] reference] child:@"users"] child:self.uid] onDisconnectRemoveValueWithCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {
        assert(error == nil);
    }];
    [[[[[WDGSync sync] reference] child:@"users"] child:self.uid] setValue:@1];
    __weak __typeof__(self) weakSelf = self;
    [[[[WDGSync sync] reference] child:@"users"] observeEventType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot *snapshot) {
        __strong __typeof__(self) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        NSMutableArray *onlineUsers = [[NSMutableArray alloc] init];
        for (WDGDataSnapshot *userSnapshot in snapshot.children) {
            if (![userSnapshot.key isEqualToString:strongSelf.uid]) {
                [onlineUsers addObject:userSnapshot.key];
            }
        }
        strongSelf.onlineUsers = [onlineUsers copy];
        [strongSelf.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.onlineUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.onlineUsers[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDGVideoUser *user = [WDGVideoUser new];
    user.uid = self.onlineUsers[indexPath.row];
    [[WDGVideoManager sharedManager] makeCallToUser:user];
}

@end
