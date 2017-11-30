//
//  WDGChatCell.h
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,WDGChatType){
    WDGChatTypeMe,
    WDGChatTypeOther
};
@class WDGChatMessageLayout;
@interface WDGChatCell : UITableViewCell
@property (nonatomic) WDGChatType type;
@property (nonatomic,strong) WDGChatMessageLayout *layout;
@end
