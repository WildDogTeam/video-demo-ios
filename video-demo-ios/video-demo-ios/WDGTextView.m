//
//  WDGTextView.m
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGTextView.h"
#import "WDGiPhoneXAdapter.h"
#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

@interface WDGTextView()<UITextViewDelegate,UIScrollViewDelegate>
{
    BOOL statusTextView;
    NSString *placeholderText;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) CGRect storeFrame;
@end


@implementation WDGTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _storeFrame =frame;
    if (self) {
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerTapClick)];
    [self addGestureRecognizer:centerTap];
    return self;
}

-(void)updateFrame:(CGRect)frame
{
    self.frame=frame;
    _storeFrame=frame;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void)createUI{
    self.textView.frame = CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
    self.placeholderLabel.frame = CGRectMake(10, 5, self.textView.frame.size.width, 39);
    self.sendButton.frame = CGRectMake(self.backGroundView.frame.size.width-55, 6, 50, self.backGroundView.frame.size.height-6*2);
    
}

-(void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}

-(UIViewController *)viewcontroller
{
    UIResponder *target =self;
    while (target.nextResponder) {
        target =target.nextResponder;
        if([target isKindOfClass:[UIViewController class]]){
            return target;
        }
    }
    return nil;
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    if(self.hidden) return;
    self.frame = [UIScreen mainScreen].bounds;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.textView.text.length == 0) {
        
        self.backGroundView.frame = CGRectMake(WDG_ViewSafeAreInsetsLeft, self.frame.size.height-height-49-(WDG_iPhoneX?0:20)-self.viewcontroller.navigationController.navigationBar.frame.size.height, self.frame.size.width-WDG_ViewSafeAreInsetsLeft, 49);
    }else{
        CGFloat backGVWidth =self.frame.size.width-WDG_ViewSafeAreInsetsLeft;
        self.textView.frame =CGRectMake(5, 6, backGVWidth-65-5, 1000);
        CGFloat backGVHeight =0;
        if(self.textView.contentSize.height<(49-6*2)){
            backGVHeight =49;
        }else if(self.textView.contentSize.height<MaxTextViewHeight){
            backGVHeight =self.textView.contentSize.height+6*2;
        }else{
            backGVHeight =MaxTextViewHeight+6*2;
        }
        CGRect rect = CGRectMake(WDG_ViewSafeAreInsetsLeft, self.frame.size.height - backGVHeight-height-(WDG_iPhoneX?0:20)-self.viewcontroller.navigationController.navigationBar.frame.size.height, backGVWidth, backGVHeight);
        self.backGroundView.frame = rect;
    }
    self.textView.frame =CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
    self.sendButton.frame = CGRectMake(self.backGroundView.frame.size.width-55, 6, 50, self.sendButton.frame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    if(self.hidden) return;
    if (self.textView.text.length == 0) {
        self.frame = _storeFrame;
        self.backGroundView.frame = CGRectMake(0, 0, self.frame.size.width, 49);
    }else{
        self.textView.frame =CGRectMake(5, 6, _storeFrame.size.width-65-5, 1000);
        CGFloat backGVHeight =0;
        if(self.textView.contentSize.height<(49-6*2)){
            backGVHeight =49;
        }else if(self.textView.contentSize.height<MaxTextViewHeight){
            backGVHeight =self.textView.contentSize.height+6*2;
        }else{
            backGVHeight =MaxTextViewHeight+6*2;
        }
        CGRect rect = CGRectMake(0, 0, _storeFrame.size.width, backGVHeight);
        self.backGroundView.frame = rect;
        self.frame = CGRectMake(_storeFrame.origin.x, _storeFrame.origin.y+49 - rect.size.height, self.backGroundView.frame.size.width, self.backGroundView.frame.size.height);
    }
    self.textView.frame =CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
    self.sendButton.frame = CGRectMake(self.backGroundView.frame.size.width-55, 6, 50, self.sendButton.frame.size.height);
    if(self.superfluousHeightWhenKeyboardHide){
        self.superfluousHeightWhenKeyboardHide(self.frame.size.height-_storeFrame.size.height);
    }
}

-(void)centerTapClick{
    [self.textView resignFirstResponder];
}




#pragma mark --- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
        [self.sendButton setBackgroundColor:UIColorRGB(180, 180, 180)];
        self.sendButton.userInteractionEnabled = NO;
    }else{
        self.placeholderLabel.text = @"";
        [self.sendButton setBackgroundColor:UIColorRGB(70 , 163, 231)];
        self.sendButton.userInteractionEnabled = YES;
    }
    CGFloat backGVHeight =0;
    if(self.textView.contentSize.height<(49-6*2)){
        backGVHeight =49;
    }else if(self.textView.contentSize.height<MaxTextViewHeight){
        backGVHeight =self.textView.contentSize.height+6*2;
    }else{
        statusTextView = YES;
        backGVHeight =MaxTextViewHeight+6*2;
    }
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    self.backGroundView.frame = CGRectMake(self.backGroundView.frame.origin.x, y - backGVHeight, self.backGroundView.frame.size.width,backGVHeight);
    self.textView.frame =CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
    
}

-(void)updateBackGroundViewForTextWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [_textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    if (curheight < 19.094) {
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(self.backGroundView.frame.origin.x, y - 49, self.backGroundView.frame.size.width, 49);
        
    }else if(curheight < MaxTextViewHeight){
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(self.backGroundView.frame.origin.x, y - _textView.contentSize.height-10, self.backGroundView.frame.size.width,_textView.contentSize.height+10);
    }else{
        statusTextView = YES;
    }
}

-(void)sendClick:(UIButton *)sender{
   
    if (self.textViewBlock) {
        self.textViewBlock(self.textView.text);
    }
    self.textView.text = nil;
    self.placeholderLabel.text = placeholderText;
    [self.sendButton setBackgroundColor:UIColorRGB(180, 180, 180)];
    self.sendButton.userInteractionEnabled = NO;
    self.frame = _storeFrame;
    self.backGroundView.frame = CGRectMake(0, 0, self.backGroundView.frame.size.width, 49);
    self.textView.frame =CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
    [self.textView endEditing:YES];
}

-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 49)];
        _backGroundView.backgroundColor = UIColorRGB(230, 230, 230);
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}

-(UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.textColor = [UIColor grayColor];
        [self.backGroundView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setBackgroundColor:UIColorRGB(180, 180, 180)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.userInteractionEnabled = NO;
        [self.backGroundView addSubview:_sendButton];
    }
    return _sendButton;
}

#pragma mark --- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusTextView == NO) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }else{
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height);
    }
}

@end
