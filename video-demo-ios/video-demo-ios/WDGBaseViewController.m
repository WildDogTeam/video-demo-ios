//
//  WDGBaseViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/11/17.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGBaseViewController.h"

@interface WDGBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WDGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.navigationController){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.navigationController.viewControllers.count > 1;
}


@end
