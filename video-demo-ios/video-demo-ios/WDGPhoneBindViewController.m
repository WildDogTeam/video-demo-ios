//
//  WDGPhoneBindViewController.m
//  video-demo-ios
//
//  Created by han wp on 2017/9/28.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGPhoneBindViewController.h"
#import "WDGImageTool.h"
#import "WDGTimer.h"
#import "WDGPhoneNumCheckValid.h"
#import "UIView+MBProgressHud.h"
#import "WilddogSDKManager.h"
#import <WilddogAuth/WilddogAuth.h>
@interface WDGTextField : UITextField
@end

@implementation WDGTextField
static float leftGap =20;
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, leftGap, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, leftGap, 0);
}

@end
@implementation WDGPhoneBindViewController
{
    WDGTextField *_phoneField;
    WDGTextField *_verificationField;
    WDGTimer *_timer;
    UIButton *_sendCodeBtn;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    float leftMargin = 22;
    float top = 61+44+20;
    float height = 50;
    float buttonWidth =110;
    UIColor *baseBackColor =[UIColor colorWithRed:221/255. green:58/255. blue:39/255. alpha:1.];
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, top, 50, height)];
    phoneView.backgroundColor = baseBackColor;
    [self.view addSubview:phoneView];
    WDGTextField *phoneField = [[WDGTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneView.frame), CGRectGetMinY(phoneView.frame), self.view.frame.size.width - leftMargin *2 -CGRectGetWidth(phoneView.frame), CGRectGetHeight(phoneView.frame))];
    phoneField.placeholder = @"请输入手机号码";
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.view addSubview:phoneField];
    _phoneField = phoneField;
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneView.frame), CGRectGetMinY(phoneView.frame), CGRectGetWidth(phoneView.frame)+CGRectGetWidth(phoneField.frame), CGRectGetHeight(phoneView.frame))];
    border1.layer.borderWidth =1;
    border1.layer.borderColor = baseBackColor.CGColor;
    [self.view addSubview:border1];
    
    UIImageView *verificationView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(border1.frame) +10, CGRectGetWidth(phoneView.frame), height)];
    verificationView.backgroundColor = [UIColor colorWithRed:221/255. green:58/255. blue:39/255. alpha:1.];
    [self.view addSubview:verificationView];
    WDGTextField *verificationField = [[WDGTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verificationView.frame), CGRectGetMinY(verificationView.frame), self.view.frame.size.width - leftMargin *2 -CGRectGetWidth(verificationView.frame) -buttonWidth, CGRectGetHeight(verificationView.frame))];
    verificationField.placeholder = @"请输入短信验证码";
    verificationField.keyboardType = UIKeyboardTypeNumberPad;
    verificationField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.view addSubview:verificationField];
    _verificationField =verificationField;
    UIButton *sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCodeBtn.frame =CGRectMake(CGRectGetMaxX(verificationField.frame), CGRectGetMinY(verificationView.frame), buttonWidth, CGRectGetHeight(verificationView.frame));
    [sendCodeBtn addTarget:self action:@selector(sendCodeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [sendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendCodeBtn setBackgroundImage:[WDGImageTool imageFromColor:baseBackColor size:sendCodeBtn.frame.size] forState:UIControlStateNormal];
    sendCodeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [sendCodeBtn setTitleColor:[UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1.] forState:UIControlStateSelected];
    [sendCodeBtn setBackgroundImage:[WDGImageTool imageFromColor:[UIColor colorWithRed:233/255. green:233/255. blue:233/255. alpha:1.] size:sendCodeBtn.frame.size] forState:UIControlStateSelected];
    [self.view addSubview:sendCodeBtn];
    _sendCodeBtn =sendCodeBtn;
    UILabel *border2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(verificationView.frame), CGRectGetMinY(verificationView.frame), CGRectGetWidth(verificationView.frame)+CGRectGetWidth(verificationField.frame)+CGRectGetWidth(sendCodeBtn.frame), CGRectGetHeight(verificationView.frame))];
    border2.layer.borderWidth =1;
    border2.layer.borderColor = baseBackColor.CGColor;
    [self.view addSubview:border2];
    
    
    UIButton *bindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bindingBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    bindingBtn.titleLabel.textColor = [UIColor whiteColor];
    bindingBtn.frame = CGRectMake(67, CGRectGetMaxY(border2.frame)+33, self.view.frame.size.width-67*2, 41);
//    bindingBtn.center = CGPointMake(self.view.center.x, CGRectGetMaxY(border2.frame)+33+bindingBtn.frame.size.height/2);
    UIColor *normalColor = [UIColor colorWithRed:0xe6/255. green:0x50/255. blue:0x1e/255. alpha:1.];
    UIColor *highlightColor = [UIColor colorWithRed:0xf0/255. green:0x91/255. blue:0x6e/255. alpha:1.];
    [bindingBtn setBackgroundImage:[WDGImageTool imageFromColor:normalColor size:bindingBtn.frame.size] forState:UIControlStateNormal];
    [bindingBtn setBackgroundImage:[WDGImageTool imageFromColor:highlightColor size:bindingBtn.frame.size] forState:UIControlStateHighlighted];
    bindingBtn.layer.cornerRadius = CGRectGetHeight(bindingBtn.frame)*.5;
    bindingBtn.clipsToBounds =YES;
    [bindingBtn addTarget:self action:@selector(bindingPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingBtn];
}

-(void)sendCodeBtnDidClick:(UIButton *)btn
{
    __weak typeof(self) WS = self;
    if(btn.selected) return;
    [WDGPhoneNumCheckValid phoneNumber:_phoneField.text isValid:^(BOOL isValid, NSString *reason) {
        __strong typeof(WS) self = WS;
        if(isValid){
            if(btn.selected) return;
            btn.selected =!btn.selected;
            [self sendCode];
        }else{
            [self.view showHUDWithMessage:@"请输入正确的手机号码" hideAfter:1 animate:YES];
        }
    }];
    
}

-(void)sendCode
{
    [[WilddogSDKManager sharedManager].wilddogVideoAuth.currentUser setValue:_phoneField.text forKey:@"phone"];
    __weak typeof(self) WS =self;
    [[WilddogSDKManager sharedManager].wilddogVideoAuth.currentUser sendPhoneVerificationWithCompletion:^(NSError * _Nullable error) {
        __strong typeof(WS) self =WS;
        if(!error){
            _timer =[WDGTimer timerWithstart:60 interval:-1 block:^(NSTimeInterval timeInterval) {
                if(timeInterval==0){
                    [_sendCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    _sendCodeBtn.selected = NO;
                    [_timer invalidate];
                    _timer = nil;
                }
                [_sendCodeBtn setTitle:[NSString stringWithFormat:@"%ds",(int)timeInterval] forState:UIControlStateSelected];
            }];
        }else{
            _sendCodeBtn.selected = NO;
            [self.view showHUDWithMessage:@"请稍后再试" hideAfter:1 animate:YES];
        }
    }];
}

-(void)bindingPhone
{
    if(_verificationField.text.length==0) return;
    [[WilddogSDKManager sharedManager].wilddogVideoAuth.currentUser verifyPhoneWithSmsCode:_verificationField.text completion:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            NSLog(@"chenggong");
        }
    }];
}

@end
