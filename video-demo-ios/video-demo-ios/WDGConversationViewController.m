//
//  WDGConversationViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGConversationViewController.h"
#import "WDGConversationsHistory.h"
#import "WDGConversationCell.h"
@interface WDGConversationViewController ()
@end

@implementation WDGConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!WDGConversationsHistory.count){
        [self showEmptyView];
    }else{
        [self hideEmptyView];
    }
    [self.tableView reloadData];
}

-(void)showEmptyView
{
    [self showEmptyViewNamed:@"no-user" size:CGSizeMake(150, 150) title:@"暂无通话记录"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return WDGConversationsHistory.count>30?30:WDGConversationsHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDGConversationCell *cell =[tableView dequeueReusableCellWithIdentifier:@"histroyCell"];
    [cell showWithNickName:[WDGConversationsHistory itemAtIndex:indexPath.row].uid time:@"通话时长:1秒" detail:@"刚刚" iconUrl:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=900872169,3830952677&fm=58&u_exp_0=333838554,3497647267&fm_exp_0=86&bpow=1000&bpoh=1503"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
@end
