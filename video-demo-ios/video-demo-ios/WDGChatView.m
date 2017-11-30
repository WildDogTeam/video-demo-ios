//
//  WDGChatView.m
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGChatView.h"
#import "WDGChatViewModel.h"
#import "WDGTextView.h"
@interface WDGChatView()
@property (nonatomic,strong) WDGChatViewModel *viewModel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) WDGTextView *textView;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *roomId;

@end

@implementation WDGChatView

+(instancetype)viewWithNickname:(NSString *)nickname roomId:(NSString *)roomId frame:(CGRect)frame
{
    WDGChatView *view = [[WDGChatView alloc] initWithFrame:frame];
    view.nickname = nickname;
    view.roomId =roomId;
    [view createSubViews];
    return view;
}

-(void)createSubViews
{
    self.viewModel = [WDGChatViewModel viewModelWithNickname:_nickname roomId:_roomId];
    [self addTableView];
    [self addMessageView];
}

-(void)addTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-49) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithRed:32/255. green:35/255. blue:42/255. alpha:1.];
    tableView.dataSource = self.viewModel;
    tableView.delegate = self.viewModel;
    self.viewModel.tableView =tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [self addSubview:_tableView];
}

-(void)addMessageView
{
    _textView = [[WDGTextView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-49, self.frame.size.width, 49)];
    [_textView setPlaceholderText:@"请输入..."];
    __weak typeof(self) WS =self;
    _textView.textViewBlock = ^(NSString *message){
        [WS.viewModel sendMessage:message];
    };
    [self addSubview:_textView];
    
}

@end
