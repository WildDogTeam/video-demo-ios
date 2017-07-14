//
//  WDGReciveCallViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGReciveCallViewController.h"

@interface WDGReciveCallViewController ()
@property (nonatomic,copy) NSString *callerID;
@property (nonatomic,copy) void(^userAccept)(BOOL);
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@end

@implementation WDGReciveCallViewController

+(instancetype)controllerWithCallerID:(NSString *)ID userAccept:(void (^)(BOOL))accept
{
    WDGReciveCallViewController *receiveController = [[WDGReciveCallViewController alloc] init];
    receiveController.callerID = ID;
    receiveController.userAccept = accept;
    receiveController.view.frame = [UIScreen mainScreen].bounds;
    return receiveController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.idLabel.text =self.callerID;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{}

- (IBAction)reject {
    _userAccept(NO);
}
- (IBAction)accept {
    _userAccept(YES);
}

@end
