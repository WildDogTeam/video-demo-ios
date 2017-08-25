//
//  WDGSelectViewController.m
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGSelectViewController.h"
#import "WDGVideoConfig.h"
@interface WDGSelectViewController ()<UIActionSheetDelegate>

@end

@implementation WDGSelectViewController
{
    NSArray *_dataList;
    NSString *_actionTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
//    self.view.alpha =0.7;
    self.view.alpha =0;
    NSLog(@"%@",_style == SelectStyleBeauty?@"beauty":@"definition");
    // Do any additional setup after loading the view.
    [self showActionSheet];
}

-(UIActionSheet *)getMyActionSheet
{
    UIActionSheet *actionSheet = nil;
    if(_style == SelectStyleDefinition){
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"切换清晰度" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"360p",@"480p",@"720p",@"1080p", nil];
    }
    if(_style == SelectStyleBeauty){
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"切换美颜方案" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Camera360",@"TuSDK",@"不使用美颜", nil];
    }
    return actionSheet;
}

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [self getMyActionSheet];
    [actionSheet showInView:self.view];
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.cancelButtonIndex){
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    NSString *string = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSLog(@"%@",string);
    if(_style == SelectStyleDefinition){
        if([string isEqualToString:@"不使用美颜"]) string = @"Beauty";
        [WDGVideoConfig setVideoConstraints:string];
    }else if(_style == SelectStyleBeauty){
        [WDGVideoConfig setBeautyPlan:string];
    }
    if(self.complete){
        self.complete(string);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
