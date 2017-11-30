//
//  WDGTextView.m
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGTextView.h"
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

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void)createUI{
    self.textView.frame = CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
    self.placeholderLabel.frame = CGRectMake(10, 5, self.textView.frame.size.width, 39);
    self.sendButton.frame = CGRectMake(self.backGroundView.frame.size.width-55, 8, 50, self.backGroundView.frame.size.height-6*2);
    
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
    self.frame = [UIScreen mainScreen].bounds;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.textView.text.length == 0) {
        
        self.backGroundView.frame = CGRectMake(_storeFrame.origin.x, self.frame.size.height-height-49-20-self.viewcontroller.navigationController.navigationBar.frame.size.height, self.backGroundView.frame.size.width, 49);
    }else{
        CGRect rect = CGRectMake(_storeFrame.origin.x, self.frame.size.height - self.backGroundView.frame.size.height-height-20-self.viewcontroller.navigationController.navigationBar.frame.size.height, self.backGroundView.frame.size.width, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    if (self.textView.text.length == 0) {
        self.frame = _storeFrame;
        self.backGroundView.frame = CGRectMake(0, 0, self.backGroundView.frame.size.width, 49);
    }else{
        CGRect rect = CGRectMake(0, 0, self.backGroundView.frame.size.width, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
        self.frame = CGRectMake(_storeFrame.origin.x, _storeFrame.origin.y+49 - rect.size.height, self.backGroundView.frame.size.width, self.backGroundView.frame.size.height);
    }
    self.textView.frame =CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
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
    
    CGSize size = CGSizeMake(self.backGroundView.frame.size.width-65, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    if (curheight < 19.094) {
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(_storeFrame.origin.x, y - 49, self.backGroundView.frame.size.width, 49);
        
    }else if(curheight < MaxTextViewHeight){
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(_storeFrame.origin.x, y - textView.contentSize.height-10, self.backGroundView.frame.size.width,textView.contentSize.height+10);
    }else{
        statusTextView = YES;
        return;
    }
    self.textView.frame =CGRectMake(5, 6, self.backGroundView.frame.size.width-65-5, self.backGroundView.frame.size.height-6*2);
    
}

-(void)sendClick:(UIButton *)sender{
    [self.textView endEditing:YES];
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
        
    }
}

@end
