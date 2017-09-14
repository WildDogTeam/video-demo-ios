//
//  WDGSettingViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGSettingViewController.h"
#import "WDGSelectViewController.h"
#import "WDGVideoConfig.h"
#import "WDGLoginManager.h"
@interface WDGSettingViewController ()<UIAlertViewDelegate>

@end

@implementation WDGSettingViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.translucent =NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidAppear:(BOOL)animated
{
    UITableViewCell *cell =[self.tableView viewWithTag:10];
    cell.detailTextLabel.text = [WDGVideoConfig videoConstraints];
    cell =[self.tableView viewWithTag:11];
    cell.detailTextLabel.text =[WDGVideoConfig beautyPlan];
    [super viewDidAppear:animated];
}

-(void)show
{
    WDGSelectViewController *c = [WDGSelectViewController new];
    c.style = SelectStyleDefinition;
    self.modalPresentationStyle =UIModalPresentationCurrentContext;
    [self presentViewController:c animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak typeof(self) WS =self;
    if([segue.identifier isEqualToString:@"definition"]){
        WDGSelectViewController *c = segue.destinationViewController;
        c.style = SelectStyleDefinition;
        c.modalPresentationStyle =UIModalPresentationOverCurrentContext;
        c.complete = ^(NSString *ans){
            UITableViewCell *cell =[WS.tableView viewWithTag:10];
            cell.detailTextLabel.text =ans;
        };
        return;
    }
    if([segue.identifier isEqualToString:@"beauty"]){
        WDGSelectViewController *c = segue.destinationViewController;
        c.style = SelectStyleBeauty;
        c.modalPresentationStyle =UIModalPresentationOverCurrentContext;
        c.complete = ^(NSString *ans){
            UITableViewCell *cell =[WS.tableView viewWithTag:11];
            cell.detailTextLabel.text =ans;
        };
        return;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) return 80;
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否退出登录" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [WDGLoginManager logOut];
    }
}

@end
