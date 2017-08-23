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
#import "WDGVideoCallViewController.h"
#import "WDGVideoTool.h"
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
    WDGConversationItem *item = [WDGConversationsHistory itemAtIndex:indexPath.row];
    NSString *timeStr = nil;
    NSInteger minute =item.conversationTime/60;
    if(minute==0){
        timeStr = [NSString stringWithFormat:@"通话时长:%ld秒",item.conversationTime%60];
    }else{
        timeStr = [NSString stringWithFormat:@"通话时长:%d分",(int)(ceil(item.conversationTime/60.0))];
    }
    NSString *detailText = [WDGVideoTool conversationDetailTimeForTimeInterval:item.finishTime];
    [cell showWithNickName:item.description time:timeStr detail:detailText iconUrl:item.faceUrl];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDGVideoItem *item = [WDGConversationsHistory itemAtIndex:indexPath.row];
    if(item){
        WDGVideoViewController *vc = [WDGVideoCallViewController makeCallToUserItem:item];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
@end
