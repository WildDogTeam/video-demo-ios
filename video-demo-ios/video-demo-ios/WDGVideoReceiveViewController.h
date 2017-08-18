//
//  WDGVideoReceiveViewController.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/5.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGVideoViewController.h"
@class WDGConversation;
@interface WDGVideoReceiveViewController : WDGVideoViewController
+(instancetype)receiveCallWithConversation:(WDGConversation *)conversation;
@end
