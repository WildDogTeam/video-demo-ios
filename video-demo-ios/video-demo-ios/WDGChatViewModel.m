//
//  WDGChatViewModel.m
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGChatViewModel.h"
#import <WilddogSync/WDGSync.h>
#import <WilddogAuth/WilddogAuth.h>
#import "WDGChatMessageLayout.h"
#import "WDGChatCell.h"
@interface WDGChatViewModel()
@property (nonatomic,strong) NSMutableArray <WDGChatMessageLayout *>*chatMessages;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *roomId;
@end

@implementation WDGChatViewModel
+(instancetype)viewModelWithNickname:(NSString *)nickname roomId:(NSString *)roomId
{
    return [[self alloc] initWithNickname:nickname roomId:roomId];
}

- (instancetype)initWithNickname:(NSString *)nickname roomId:(NSString *)roomId
{
    self = [super init];
    if (self) {
        self.nickname =nickname;
        self.roomId = roomId;
        [self initData];
    }
    return self;
}

-(void)initData
{
    _chatMessages = [NSMutableArray array];
    [[[[WDGSync sync] reference] child:[NSString stringWithFormat:@"%@/chat",_roomId]] observeEventType:WDGDataEventTypeChildAdded withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@",snapshot.value);
//        NSEnumerator *enmerator =snapshot.children;
//        WDGDataSnapshot *obj =nil;
//        while ((obj = enmerator.nextObject)) {
            if([snapshot.value isKindOfClass:[NSDictionary class]]){
                NSDictionary *dict = snapshot.value;
                NSLog(@"%@",dict);
//                if([dict[@"uid"] isKindOfClass:[NSNumber class]]){
//                    assert(0);
//                }
                WDGChatMessage *message = [WDGChatMessage new];
                message.uid = [NSString stringWithFormat:@"%@",dict[@"uid"]] ;
                message.nickname = [NSString stringWithFormat:@"%@",dict[@"author"]];
                message.message = [NSString stringWithFormat:@"%@",dict[@"message"]];
                WDGChatMessageLayout *layout = [WDGChatMessageLayout layoutWithmessage:message];
                [self.chatMessages addObject:layout];
            }
//        }
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatMessages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDGChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if(!cell){
        cell = [[WDGChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
    }
    cell.layout = self.chatMessages[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.chatMessages[indexPath.row].height;
}

-(void)sendMessage:(NSString *)message
{
    NSLog(@"sendMessage");
    NSString *uid = [WDGAuth auth].currentUser.uid;
    NSDictionary *dict =@{@"author":_nickname,@"message":message,@"uid":uid};
    [[[[[WDGSync sync] reference] child:[NSString stringWithFormat:@"%@/chat",_roomId]] childByAutoId] setValue:dict];
}
@end
