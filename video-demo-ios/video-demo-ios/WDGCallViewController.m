//
//  WDGCallViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGCallViewController.h"
#import "WDGVideoCallViewController.h"
#import "UIView+MBProgressHud.h"
#import "WDGAccount.h"
#import "WilddogSDKManager.h"
#import "WDGImageTool.h"
#import "WDGVideoControllerManager.h"
@interface WDGCallViewController ()
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UITextField *oppoIdField;

@end

@implementation WDGCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.oppoIdField becomeFirstResponder];
    UIColor *normalColor = [UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.];
    UIColor *highlightColor = [UIColor colorWithRed:0xf0/255. green:0x91/255. blue:0x6e/255. alpha:1.];
    [self.callButton setBackgroundImage:[WDGImageTool imageFromColor:normalColor size:self.callButton.frame.size] forState:UIControlStateNormal];
    [self.callButton setBackgroundImage:[WDGImageTool imageFromColor:highlightColor size:self.callButton.frame.size] forState:UIControlStateHighlighted];
    self.callButton.layer.cornerRadius = CGRectGetHeight(self.callButton.frame)*.5;
    self.callButton.clipsToBounds =YES;
    [self.callButton addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)makeCall
{
    if(_oppoIdField.text.length == 0){
        [self.view showHUDWithMessage:@"用户ID不能为空" hideAfter:1 animate:YES];
        return;
    }
    if([_oppoIdField.text isEqualToString:[WDGAccountManager currentAccount].userID]){
        [self.view showHUDWithMessage:@"不能拨打给自己" hideAfter:1 animate:YES];
        return;
    }
    __weak typeof(self) WS =self;
    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        __strong typeof(WS) self =WS;
        if([(NSDictionary *)snapshot.value objectForKey:_oppoIdField.text]){
            [self callOppoUid];
        }else{
            [self.view showHUDWithMessage:@"当前ID不存在" hideAfter:1 animate:YES];
        }
    }];
}

-(void)callOppoUid
{
    [WDGVideoUserItem requestForUid:_oppoIdField.text complete:^(WDGVideoUserItem *item) {
        [[WDGVideoControllerManager sharedManager] makeCallToUserItem:item inViewController:self];
//        WDGVideoViewController *vc = [WDGVideoCallViewController makeCallToUserItem:item];
//        [self presentViewController:vc animated:YES completion:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
