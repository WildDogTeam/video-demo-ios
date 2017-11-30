//
//  WDGTextView.h
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MaxTextViewHeight 80 
@interface WDGTextView : UIView
@property (nonatomic,copy) void (^textViewBlock)(NSString *text);
- (void)setPlaceholderText:(NSString *)text;

@end
