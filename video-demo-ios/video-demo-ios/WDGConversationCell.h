//
//  WDGConversationCell.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/14.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGConversationCell : UITableViewCell
-(void)showWithNickName:(NSString *)nickname time:(NSString *)time detail:(NSString *)detail iconUrl:(NSString *)iconurl;
@end
