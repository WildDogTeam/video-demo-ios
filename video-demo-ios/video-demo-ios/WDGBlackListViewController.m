//
//  WDGBlackListViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/10/7.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGBlackListViewController.h"

@interface WDGBlackListViewController ()

@end

@implementation WDGBlackListViewController

- (instancetype)init
{
    self = [super initForTyoe:SettingDetailTypeBlackList];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.detailType = SettingDetailTypeBlackList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
