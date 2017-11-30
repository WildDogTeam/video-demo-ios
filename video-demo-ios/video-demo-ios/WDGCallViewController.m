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
#import "WDGRoomViewController.h"
#import "WDGComplexRoomViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define Screenheight [UIScreen mainScreen].bounds.size.height
#define HorizontalScreenScale (ScreenWidth/375)
#define VerticalScreenScale (Screenheight/667)

@interface WDGCallViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UITextField *oppoIdField;
@property (weak, nonatomic) IBOutlet UIButton *videoModelBtn;
@property (weak, nonatomic) IBOutlet UIButton *interactionModelBtn;

@end

@implementation WDGCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.oppoIdField becomeFirstResponder];
    self.oppoIdField.delegate =self;
    UIColor *normalColor = [UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.];
    UIColor *highlightColor = [UIColor colorWithRed:0xf0/255. green:0x91/255. blue:0x6e/255. alpha:1.];
    [self.callButton setBackgroundImage:[WDGImageTool imageFromColor:normalColor size:self.callButton.frame.size] forState:UIControlStateNormal];
    [self.callButton setBackgroundImage:[WDGImageTool imageFromColor:highlightColor size:self.callButton.frame.size] forState:UIControlStateHighlighted];
    self.callButton.layer.cornerRadius = CGRectGetHeight(self.callButton.frame)*.5;
    self.callButton.clipsToBounds =YES;
    [self.callButton addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];

}

- (void)makeCall
{
    if(_oppoIdField.text.length == 0){
        [self.view showHUDWithMessage:@"房间号不能为空" hideAfter:1 animate:YES];
        return;
    }
    if(![[WDGVideoControllerManager sharedManager] conversationClosed]){
        [self.view showHUDWithMessage:@"请结束当前通话再进行拨打" hideAfter:1 animate:YES];
        return;
    }
    
    if(_videoModelBtn.selected){
        WDGRoomViewController *controller = [WDGRoomViewController roomControllerWithRoomId:_oppoIdField.text];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"masklandscaperight" object:nil];
        WDGComplexRoomViewController *controller = [WDGComplexRoomViewController roomControllerWithRoomId:_oppoIdField.text];
        [self.navigationController pushViewController:controller animated:YES];
    }
//    if([_oppoIdField.text isEqualToString:[WDGAccountManager currentAccount].userID]){
//        [self.view showHUDWithMessage:@"不能拨打给自己" hideAfter:1 animate:YES];
//        return;
//    }
//    __weak typeof(self) WS =self;
//    [[[WilddogSDKManager sharedManager].wilddogSyncRootReference child:@"users"] observeSingleEventOfType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
//        __strong typeof(WS) self =WS;
//        if([(NSDictionary *)snapshot.value objectForKey:_oppoIdField.text]){
//            [self callOppoUid];
//        }else{
//            [self.view showHUDWithMessage:@"当前ID不存在" hideAfter:1 animate:YES];
//        }
//    }];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

}

-(void)callOppoUid
{
    [WDGVideoUserItem requestForUid:_oppoIdField.text complete:^(WDGVideoUserItem *item) {
        [[WDGVideoControllerManager sharedManager] makeCallToUserItem:item inViewController:self];
//        WDGVideoViewController *vc = [WDGVideoCallViewController makeCallToUserItem:item];
//        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (IBAction)videoModelSelect:(UIButton *)sender {
    _videoModelBtn.selected =YES;
    _interactionModelBtn.selected = NO;
    [self.view endEditing:YES];
}

- (IBAction)interactionModelSelect:(UIButton *)sender {
    _interactionModelBtn.selected = YES;
    _videoModelBtn.selected =NO;
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
