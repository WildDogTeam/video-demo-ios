//
//  WDGChatViewModel.h
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGChatViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
+(instancetype)viewModelWithNickname:(NSString *)nickname roomId:(NSString *)roomId;
-(void)sendMessage:(NSString *)message;
@end
