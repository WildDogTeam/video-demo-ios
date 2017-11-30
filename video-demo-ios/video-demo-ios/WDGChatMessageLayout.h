//
//  WDGChatMessageLayout.h
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WDGChatMessageMaxWidth 250

@interface WDGChatMessage : NSObject
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *message;

@end

@interface WDGChatMessageLayout : NSObject
+(instancetype)layoutWithmessage:(WDGChatMessage *)message;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong) WDGChatMessage *message;
@end
