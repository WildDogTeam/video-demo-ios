//
//  WDGChatView.h
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGChatView : UIView
+(instancetype)viewWithNickname:(NSString *)nickname roomId:(NSString *)roomId frame:(CGRect)frame;
@end
